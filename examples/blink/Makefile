PROJ = blink
PIN_DEF = blink.pcf
TOP_MODULE = top
DEVICE = hx1k
PACKAGE = tq144
FLASH_SIZE = 1048576

PI_ADDR = 192.168.178.67
PI_USR = pi
PI_PWD = 123456


# For configuration from Pi (target "pi") place https://gist.github.com/j-marjanovic/cb271e861d279a31775d#file-conf_fpga-sh in /opt/ of pi


all: $(PROJ).rpt $(PROJ).bin

%.blif: %.v
	yosys -p 'synth_ice40 -top ${TOP_MODULE} -blif $@' $<

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^ -P $(PACKAGE)

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

pi: $(PROJ).bin
	sshpass -p ${PI_PWD} scp $(PROJ).bin ${PI_USR}@${PI_ADDR}:/tmp/
	sshpass -p ${PI_PWD} ssh -o StrictHostKeyChecking=no ${PI_USR}@${PI_ADDR} sudo /opt/conf_FPGA.sh /tmp/$(PROJ).bin

pi_flash: $(PROJ).bin
	cp $(PROJ).bin $(PROJ)_pad.bin
	dd if=/dev/null of=$(PROJ)_pad.bin bs=1 count=1 seek=${FLASH_SIZE}
	sshpass -p ${PI_PWD} scp $(PROJ)_pad.bin ${PI_USR}@${PI_ADDR}:/tmp/
	sshpass -p ${PI_PWD} ssh -o StrictHostKeyChecking=no ${PI_USR}@${PI_ADDR} /usr/sbin/flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=1000 -w /tmp/$(PROJ)_pad.bin

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).rpt $(PROJ).bin $(PROJ)_pad.bin

.PHONY: all pi clean
