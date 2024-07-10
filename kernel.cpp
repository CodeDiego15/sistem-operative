extern "C" void kernel_main() {
    const char *str = "Hello, Kernel World!";
    char *vidmem = (char*) 0xb8000;
    unsigned int i = 0;
    while (str[i] != '\0') {
        vidmem[i*2] = str[i];
        vidmem[i*2+1] = 0x07;
        i++;
    }
}

