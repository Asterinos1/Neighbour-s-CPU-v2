#include <cerrno>
#include <cstring>
#import <iostream>
#import <fstream>
#import <string>


// Define the properties of a VHDL signal
class Signal {

	public:
		int vectorUpper;
		int vectorLower;

	
};

std::fstream openFile(std::string filename) {
	std::fstream testbench;

	testbench.open(filename);
	if(testbench.fail()) {
		std::cerr << "Error: " << std::strerror(errno);
	}
	
	return testbench;
}

int intepr(std::string filename){
	
	bool unknownOpt = false;
	int option = 0;
	std::cout << "Welcome to the testbench generator\n" \
		<< "Choose an option: \n";
	
	do {
	std::cin >> option;
	
	switch(option) {
		case 1:
			
			break;
		case 2:

			break;

		default:
			std::cout << "Unknown option \n";
			unknownOpt = true;
	}

	}while(unknownOpt);
	return 0;
}

int main() {

	return 0;
}
