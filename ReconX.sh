#!/bin/bash


url=$1

if [ ! -d "$url" ];then
	mkdir $url
fi


echo " Firing-Up The Tool  "
sudo uniscan -u $url >> $url/output.txt
cat $url/output.txt | grep $1 >> $url/final.txt
echo " nmap scanning "
nmap --script=vuln $url >> $url/nmap.txt


install_waybackurls() {
    if ! command -v waybackurls &> /dev/null; then
        echo "waybackurls is not installed. Installing waybackurls..."
        # Install waybackurls (requires Go)
        if ! command -v go &> /dev/null; then
            echo "Go is not installed. Installing Go..."
            sudo apt update && sudo apt install golang -y
        fi
        go install github.com/tomnomnom/waybackurls@latest
        export PATH=$PATH:$(go env GOPATH)/bin  # Add Go bin to PATH
        echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc  # Persist PATH in bashrc
        source ~/.bashrc
    else
        echo "waybackurls is already installed."
    fi
}

install_ghauri() {
    if ! command -v ghauri &> /dev/null; then
        echo "Ghauri is not installed. Installing Ghauri..."
        # Install Ghauri (requires Python3 and pip)
        if ! command -v python3 &> /dev/null; then
            echo "Python3 is not installed. Installing Python3..."
            sudo apt update && sudo apt install python3 -y
        fi
        if ! command -v pip3 &> /dev/null; then
            echo "pip3 is not installed. Installing pip3..."
            sudo apt install python3-pip -y
        fi
        pip3 install ghauri
    else
        echo "Ghauri is already installed."
    fi
}

run_waybackurls() {
	echo "running waybackurls"
	
	waybackurls $url | waybackurls >> $url/waybackurls.txt
	
}


run_ghauri() {
    install_ghauri
    echo "Running Ghauri..."
    # Example usage of Ghauri:
    ghauri -u "$url/index.php?id=1" 
    
}



echo "choose a tool to run"

echo "1)waybackurls"

echo "2)Ghauri"

read -p "Enter the choice(1 or 2): " choice

case $choice in
	1)
		run_waybackurls
		;;

	2)
		run_ghauri
		;;

	*)
		echo "invalid choice"
		;;
esac
