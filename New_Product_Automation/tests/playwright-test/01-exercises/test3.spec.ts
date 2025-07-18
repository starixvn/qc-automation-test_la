import {test , expect} from '@playwright/test';
import { TodoPage } from '../../../page/todo-page';

test ("Exercies 3: Product page", async ({page}) =>{ 
    let todoPage = new TodoPage(page);

    await test.step("Go to Todo Page", async () =>{
        await todoPage.goToTodoPage();
    })

    await test.step("Them moi 100 todo item có noi dung 'Todo<i>'", async()=>{
        for (let i = 1 ; i<= 100; i++){
            await todoPage.addNewTask(`Todo${i}`);
        }
    })
    // await page.waitForTimeout(10000); 
    
    await test.step("Xoa cac todo co so le", async()=>{
        page.on("dialog", async dialog => {
            await dialog.accept();
        });
        for (let i = 1 ; i<= 100; i++){
            if (i % 2 !== 0){
                await todoPage.deleteTask(`Todo${i}`);
            }
        }
    })
    
    await test.step("Verify todo 90 is in viewport? ", async()=>{
        const xpathtodo90 = todoPage.getLocatorTask("Todo90");
        await expect(xpathtodo90).toBeInViewport({timeout : 10000});
    })

    await test.step("Verify todo 21 is hidden? ", async()=>{
        const xpathtodo21 = todoPage.getLocatorTask("Todo21");
        await expect(xpathtodo21).not.toBeAttached();
    })
})