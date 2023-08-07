#include <stdio.h>
#include <locale.h>

// Definição das constantes para as direções
#define NORTE 0
#define LESTE 1
#define SUL 2
#define OESTE 3

// Estrutura para representar o robô
typedef struct {
    int x; // Posição x do robô
    int y; // Posição y do robô
    int direction; // Direção do robô
} Robot;

// Função para mover o robô para a frente
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

// Função para girar o robô no sentido horário
void turnClockwise(Robot* robot) {
    robot->direction = (robot->direction + 1) % 4;
}

// Função para girar o robô no sentido anti-horário
void turnCounterClockwise(Robot* robot) {
    robot->direction = (robot->direction + 3) % 4;
}

// Função para exibir a posição e a direção do robô
void displayPosition(Robot robot) {
    printf("Posição: (%d, %d)\n", robot.x, robot.y);

    switch (robot.direction) {
        case NORTE:
            printf("Direção: NORTE\n");
            break;
        case LESTE:
            printf("Direção: LESTE\n");
            break;
        case SUL:
            printf("Direção: SUL\n");
            break;
        case OESTE:
            printf("Direção: OESTE\n");
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
        printf("\tSimulador de Robô \n\n");
        printf("1. Mover para frente\n");
        printf("2. Girar no sentido horário\n");
        printf("3. Girar no sentido anti-horário\n");
        printf("4. Exibir posição e direção\n");
        printf("5. Sair\n");
        printf("Escolha uma opção: ");
        scanf("%d", &option);

        switch (option) {
            case 1:
                moveForward(&robot);
                printf("Robô movido para frente.\n");
                break;
            case 2:
                turnClockwise(&robot);
                printf("Robô girou no sentido horário.\n");
                break;
            case 3:
                turnCounterClockwise(&robot);
                printf("Robô girou no sentido anti-horário.\n");
                break;
            case 4:
                displayPosition(robot);
                break;
            case 5:
                printf("Encerrando o programa.\n");
                break;
            default:
                printf("Opção inválida! Tente novamente.\n");
        }
    } while (option != 5);

    return 0;
}
