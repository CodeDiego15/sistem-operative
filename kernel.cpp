extern "C" void kernel_main() {
    const char *str = "Hello, OS in 64-bit mode!";
    char *video_memory = (char*)0xb8000;

    for (int i = 0; str[i] != '\0'; ++i) {
        video_memory[i * 2] = str[i];
        video_memory[i * 2 + 1] = 0x07; // Color blanco sobre negro
    }

    while (1) {
        // Loop infinito para mantener el kernel en ejecución
    }
}



