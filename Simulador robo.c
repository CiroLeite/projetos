#include <stdio.h>
#include <locale.h>

// Defini��o das constantes para as dire��es
#define NORTE 0
#define LESTE 1
#define SUL 2
#define OESTE 3

// Estrutura para representar o rob�
typedef struct {
    int x; // Posi��o x do rob�
    int y; // Posi��o y do rob�
    int direction; // Dire��o do rob�
} Robot;

// Fun��o para mover o rob� para a frente
void moveForward(Robot* robot) {
    switch (robot->direction) {
        case NORTE:
            robot->y--;
            break;
        case LESTE:
            robot->x++;
            break;
        case SUL:
            robot->y++;
            break;
        case OESTE:
            robot->x--;
            break;
    }
}

// Fun��o para girar o rob� no sentido hor�rio
void turnClockwise(Robot* robot) {
    robot->direction = (robot->direction + 1) % 4;
}

// Fun��o para girar o rob� no sentido anti-hor�rio
void turnCounterClockwise(Robot* robot) {
    robot->direction = (robot->direction + 3) % 4;
}

// Fun��o para exibir a posi��o e a dire��o do rob�
void displayPosition(Robot robot) {
    printf("Posi��o: (%d, %d)\n", robot.x, robot.y);

    switch (robot.direction) {
        case NORTE:
            printf("Dire��o: NORTE\n");
            break;
        case LESTE:
            printf("Dire��o: LESTE\n");
            break;
        case SUL:
            printf("Dire��o: SUL\n");
            break;
        case OESTE:
            printf("Dire��o: OESTE\n");
            break;
    }
}

int main() {
	setlocale(LC_ALL, "Portuguese");
    Robot robot;
    robot.x = 0;
    robot.y = 0;
    robot.direction = NORTE;

    int option;

    do {
        printf("\tSimulador de Rob� \n\n");
        printf("1. Mover para frente\n");
        printf("2. Girar no sentido hor�rio\n");
        printf("3. Girar no sentido anti-hor�rio\n");
        printf("4. Exibir posi��o e dire��o\n");
        printf("5. Sair\n");
        printf("Escolha uma op��o: ");
        scanf("%d", &option);

        switch (option) {
            case 1:
                moveForward(&robot);
                printf("Rob� movido para frente.\n");
                break;
            case 2:
                turnClockwise(&robot);
                printf("Rob� girou no sentido hor�rio.\n");
                break;
            case 3:
                turnCounterClockwise(&robot);
                printf("Rob� girou no sentido anti-hor�rio.\n");
                break;
            case 4:
                displayPosition(robot);
                break;
            case 5:
                printf("Encerrando o programa.\n");
                break;
            default:
                printf("Op��o inv�lida! Tente novamente.\n");
        }
    } while (option != 5);

    return 0;
}
