package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/codecat/go-enet"
)

func getHighscore() (string, string, string) {
	file, err := os.ReadFile("data/highscore.txt")
	if err != nil {
		return "0", "", ""
	}
	content := string(file)
	parts := strings.Split(strings.TrimSpace(content), ";")
	if len(parts) != 3 {
		return "0", "", ""
	}
	return parts[0], parts[1], parts[2]
}

func saveScore(score string, playerName string, playerIP string) error {
	currentScore, _, _ := getHighscore()
	currentScoreInt := 0
	newScoreInt := 0
	fmt.Sscanf(currentScore, "%d", &currentScoreInt)
	fmt.Sscanf(score, "%d", &newScoreInt)

	if newScoreInt > currentScoreInt {
		content := fmt.Sprintf("%s;%s;%s", score, playerName, playerIP)
		return os.WriteFile("data/highscore.txt", []byte(content), 0644)
	}
	return nil
}

func main() {
	enet.Initialize()
	defer enet.Deinitialize()
	currentHighscore, currentHighscoreIP, _ := getHighscore()
	fmt.Println(currentHighscore, currentHighscoreIP)
	host, err := enet.NewHost(enet.NewListenAddress(6969), 32, 1, 0, 0)
	if err != nil {
		return
	}
	defer host.Destroy()

	fmt.Println("Server na 0.0.0.0:6969")

	for {
		ev := host.Service(1000)
		if ev.GetType() == enet.EventNone {
			continue
		}

		switch ev.GetType() {
		case enet.EventConnect:
			fmt.Println("New con:", ev.GetPeer().GetAddress())

		case enet.EventDisconnect:
			fmt.Println("Discon:", ev.GetPeer().GetAddress())

		case enet.EventReceive:
			packet := ev.GetPacket()
			defer packet.Destroy()

			data := string(packet.GetData())
			fmt.Println("packet:", data)

			if data == "get_highscore" {
				currentScore, playerName, playerIP := getHighscore()
				highscoreMessage := fmt.Sprintf("highscore:%s;%s;%s", currentScore, playerName, playerIP)
				ev.GetPeer().SendString(highscoreMessage, ev.GetChannelID(), enet.PacketFlagReliable)
			} else if strings.Contains(data, "gameover:") {
				parts := strings.Split(data, ":")
				if len(parts) == 2 {
					remainingParts := strings.Split(strings.TrimSpace(parts[1]), ";")
					if len(remainingParts) == 2 {
						score := remainingParts[0]
						playerName := remainingParts[1]
						playerIP := ev.GetPeer().GetAddress().String()
						err := saveScore(score, playerName, playerIP)
						if err != nil {
							continue
						} else {
							fmt.Printf("gg %s balls hrac %s s IP: %s\n", score, playerName, playerIP)
						}
					}
				}
			}
		}
	}
}
