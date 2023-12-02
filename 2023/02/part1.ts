
const file = Bun.file("input.txt");

const input = await file.text();

const lines = input.trim().split("\n");

class Game {

	id: number;
	rounds: Round[];
	
	constructor(input:string) {
		const [name, res] = input.split(":");
		this.id = Number(name.split(" ")[1]);
		this.rounds = res.split(";").map(round =>
			round.split(",").reduce<Round>((p: Round, s) => {
				let [amt, name] = s.trim().split(" ");
				p[name] = Number(amt);
				return p;
			}, {green: 0, red: 0, blue: 0})
		);
	}

	validate(limits: Round): boolean {
		return this.rounds.every(round => 
			Object.keys(round).every(color => round[color] <= limits[color])
		);
	}

}

interface Round {
	red: number,
	green: number,
	blue: number,
}

const games: Game[] = lines.map(line => new Game(line));

const limits = {
	red: 12,
	green: 13,
	blue: 14,
}

console.log(games.reduce((p, game) => p + (game.validate(limits) ? game.id : 0), 0))

