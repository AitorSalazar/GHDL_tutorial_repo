import cocotb
from cocotb.triggers import RisingEdge, Timer


async def generate_clock(dut):
    """Generate clock pulses."""
    while True:
        dut.CLK.value = 0
        await Timer(5, units="ns")
        dut.CLK.value = 1
        await Timer(5, units="ns")


@cocotb.test()
async def test_mcd_machine(dut):
    """Test MCD_Machine with different input patterns."""

    # Start the clock generator
    cocotb.start_soon(generate_clock(dut))

    # Constants and input patterns
    pattern_a = ["01101001", "00111000", "01001011", "01110000", "01010100"]
    pattern_b = ["00111111", "00001110", "00110100", "00101100", "01101010"]
    pattern_res = ["00010101", "00001110", "00000001", "00000100", "00000010"]
    
    dut.enter.value = 0
    dut.reset.value = 0
    dut.a.value = 0
    dut.b.value = 0

    await Timer(0.5, units="ms")

    for i in range(len(pattern_a)):
        # Enter A
        dut.a.value = int(pattern_a[i], 2)
        dut.enter.value = 1
        await Timer(100, units="us")
        dut.enter.value = 0
        await Timer(100, units="us")

        # Enter B
        dut.a.value = 0
        dut.b.value = int(pattern_b[i], 2)
        dut.enter.value = 1
        await Timer(100, units="us")
        dut.enter.value = 0
        await Timer(100, units="us")

        dut.b.value = 0
        await Timer(1, units="ms")

        mcd_value = int(dut.mcd.value)
        expected_value = int(pattern_res[i], 2)
        
        dut._log.info(f"The value of MCD is: {mcd_value:08b}")
        assert mcd_value == expected_value, f"Wrong MCD value: expected {expected_value:08b}, got {mcd_value:08b}"

        # Prepare for the next operation
        dut.enter.value = 1
        await Timer(100, units="us")
        dut.enter.value = 0
        await Timer(100, units="us")

    await Timer(1, units="ms")
