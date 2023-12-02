
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

	minimum(): Round {
		return this.rounds.reduce((p, round) => {return{
			red: Math.max(round.red, p.red),
			green: Math.max(round.green, p.green),
			blue: Math.max(round.blue, p.blue)
		}}, {green: 0, red: 0, blue: 0})
	}

	power(): number {
		const min = this.minimum();
		return min.green * min.red * min.blue;
	}

}

interface Round {
	red: number,
	green: number,
	blue: number,
}

const games: Game[] = lines.map(line => new Game(line));

console.log(games.reduce((total,game)=>total+game.power(),0));

