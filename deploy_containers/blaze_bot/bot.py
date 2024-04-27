from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from time import sleep

PASS = "Super_Secure_Password MCSC{__//|__y0u_d3s3rve_a_m3d4l_n0t_g0nna_lie_:D__|\\\\__}"

allBlazes = "/html/body/div[1]/div/div/div[2]/nav/div[3]/a"
inputPass = "/html/body/div[1]/div/main/article/div/div/div[2]/input"
sendBtn = "/html/body/div[1]/div/main/article/div/div/div[3]/button"
suppBtn = "/html/body/div[1]/div/main/div/button"

url = "http://nginx:80"


def check():
    options = webdriver.ChromeOptions()
    options.add_argument("--headless=new")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")

    driver = webdriver.Chrome(options=options)

    driver.get(url)
    sleep(1)

    elem = driver.find_element(By.XPATH, allBlazes)
    elem.click()

    elem = driver.find_element(By.XPATH, inputPass)
    elem.send_keys(PASS)

    elem = driver.find_element(By.XPATH, sendBtn)
    elem.click()
    sleep(1)

    original_url = driver.current_url

    elem = driver.find_element(By.XPATH, suppBtn)
    elem.click()
    sleep(3)

    # Check for exploit
    if original_url != driver.current_url:
        print("Found a different url: " + driver.current_url)
        try:
           elem = driver.find_element(By.XPATH, inputPass)
           elem.send_keys(PASS)

           elem = driver.find_element(By.XPATH, sendBtn)
           elem.click()
        except:
            print("Bad html structure")

def check_loop():
    while 1:
        print("Sleeping zzzz....")
        sleep(30) # Sleep 30sec and check
        print("Starting Check!")
        check()
        print("Check is done")

def main():
    print("Starting leBot")
    check_loop()


if __name__ == '__main__':
    main()
