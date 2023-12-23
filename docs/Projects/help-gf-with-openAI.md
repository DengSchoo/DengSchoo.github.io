# 【教程】从0到1调用ChatGPT快速帮女朋友赚外快

> 本文记录学习openAI接入学习过程（Python版）以及小项目实战。

## 1.背景

最近npy找到了一个模型效果评估的任务，主要内容是从专业角度出发评估他们的模型的优化效果，一组优化效果评估由一个原始英语句子，三个他们模型简化总结后的句子。

要求从以下三个方面评估三个简化后的效果：

- 简洁性：不是简单句扣1分、意译为更简单的就比另外两句多1分；
- 流畅性：曲解句子一处扣1分、标点符号不准确扣1分、语法or搭配不对扣1分；
- 充分性：漏译一处扣1分

一个例子：

```
105复杂句：Convinced that the grounds were haunted, they decided to publish their findings in a book An Adventure (1911), under the pseudonyms of Elizabeth Morison and Frances Lamont.
简化句1：They believed the grounds were haunted. They decided to publish their findings in a book. They used the names of Elizabeth Morison and Frances Lamont.
简化句2：Convinced that the grounds were haunted, they decided to publish what they found in a book called An Adventure. They used the names Elizabeth Morison and Frances Lamont.
简化句3：Convinced that the grounds were haunted, they decided to publish their findings in a book called An Adventure (1911). They used the names Elizabeth Morison and Frances Lamont.
句1得分：流畅性[]；简洁性[]；充分性[]
句2得分：流畅性[]；简洁性[]；充分性[]
句3得分：流畅性[]；简洁性[]；充分性[]
```

`[]`中写你的评分，满分5分，共句子组有380+组，如果人工评估的话过于麻烦了，在这个场景使用chatgpt最合适不过，于是开始着手开发一个小项目来实现快速的评估。

## 2.环境准备

### 2.1 OpenAI账号准备

[Overview - OpenAI API](https://platform.openai.com/overview)

需要准备以下账号：

- 谷歌账号：Gmail（国内手机号即可注册）
- OpenAI账号（使用谷歌账号快速登陆）

### 2.2 OpenAI-Keys准备

[API Reference - OpenAI API](https://platform.openai.com/api-keys)

申请OpenApi-Keys的时候需要接外国手机号的验证码，所以还需要接码平台。

便宜接码平台：因为新手机号有额外13美元免费额度，绑定过的手机号接码平台只有5美金免费额度，也够用了。

- [onlinesim.io](https://onlinesim.io/)（1美元起充，我用的这个，推荐）
- [SMS-Activate](https://sms-activate.org/cn)(2美元起充)

最后自己创建一个自己的API Keys即可（需要自己复制到其他地方，只展示一次，可以删除再创接）：

<img src="https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312231109822.png" alt="image-20231223110952749" style="zoom:33%;" />

### 2.3 开发环境

OpenAPI最新官方文档：[API Reference - OpenAI API](https://platform.openai.com/docs/api-reference/introduction)

我这里参照了老版本的教程，新老都可以，版本影响的是endpoint，endpoint决定之差哪些模型调用。这里给出我的环境准备。

- python就不说了
- `pip install openai==0.27.0`只需要这个依赖

## 3.代码详解

> 因为本身不是专业写python的，代码有点矬但是能跑就行。

```python
from time import sleep

import openai
import json

# 填你的秘钥
openai.api_key = "sk-xxxxxx"
# 一些元数据
aspects = ['Conciseness', 'Fluency', 'Sufficiency']
students = ['A', 'B', 'C']


# 提问代码
def chat_gpt(prompt) -> str:
    # 你的问题

    # 老版本调用写法，不支持调用gpt-3.5-turbo
    
    # # 调用 ChatGPT 接口
    # model_engine = "text-davinci-003"
    # # model_engine = "gpt-3.5-turbo"
    # completion = openai.Completion.create(
    #     engine=model_engine,
    #     prompt=prompt,
    #     max_tokens=1024,
    #     n=1,
    #     stop=None,
    #     temperature=0.5,
    # )
    #
    # response = completion.choices[0].text
    # return response
    # Call the OpenAI API to generate a response
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[{'role': 'user', 'content': prompt}],
        max_tokens=1024,
        n=1,
        temperature=0.5,
        top_p=1,
        frequency_penalty=0.0,
        presence_penalty=0.6,
    )
    # Get the response text from the API response
    response_text = response['choices'][0]['message']['content']
    
    # OPENAI自己做了流控，具体看官网
    sleep(21)
    return response_text


result_tmplate = f'句1得分：流畅性[]；简洁性[]；充分性[]'

no_need = '[]'

if __name__ == '__main__':

    separator = '：'

    # read file
    fr = open("formatted_sentences_100_250.txt", "r")
    fo = open("formatted_sentences_result_100-250.txt", "w+")
    sentences = []
    cnt = 0
    max_cnt = 400
    for line in fr:
        if cnt > max_cnt:
            break
        if line.find(separator) == -1 or line.find(no_need) != -1:
            continue
        sentence = line.split(separator)[1]
        sentences.append(sentence)
        fo.write(line)
        if len(sentences) == 4:
            # 处理结果
            promt = (
                f'From now on you are a teacher who is responsible for grading students("A", "B", "C") on the simplified results of the original sentences you propose out on a scale of 5. '
                f'From the following three aspects: {aspects[0]}, {aspects[1]}, {aspects[2]}'
                'Here is a example:'
                f'original：{sentence[0]}'
                f'"A":{sentence[1]}'
                f'"B":{sentence[2]}'
                f'"C":{sentence[3]}'
                f"Evaluate the score for students(\"A\", \"B\", \"C\") with the above three aspects('{aspects[0]}', '{aspects[1]}', '{aspects[2]}')."
                "Your answer can only and just be returned in pure JSON format that can be serialized into dict format in Python."
            )
            gpt = chat_gpt(promt).replace('Answer:', '')
            load = dict(json.loads(gpt))
            tmp_load = {}
            flag = False
            # 修正数据，可能格式不是想要的A：..而是Conciseness：‘A’
            for key, value in load.items():
                if len(key) > 1:
                    flag = True
                    for k, v in value.items():
                        if k not in tmp_load.keys():
                            tmp_load[k] = {}
                        tmp_load[k][key] = v
            if flag:
                load = tmp_load
            for idx, student in enumerate(students):
                scores = []
                rating = load.get(student)
                for aspect in aspects:
                    for k, v in rating.items():
                        if k.lower().count(aspect.lower()) != 0:
                            scores.append(v)
                            break
                result_template = f'句{idx + 1}得分：流畅性[{scores[0]}]；简洁性[{scores[1]}]；充分性[{scores[2]}]\n'
                if idx == len(students) - 1:
                    result_template += '\n'
                fo.write(result_template)
            cnt += 1
            sentences = []
            print(f'cur group at = {cnt}')
            if cnt >= max_cnt:
                break

    fo.close()
    fr.close()
    print(f'done, {cnt} sentences group is processed.')

```



## 4.效果展示

大概每分钟调用三次OPENAI接口（因为OPENAI做了流量控制），速度还是有点慢，后面又给npy创建了一个账号，流控只针对单API Key，所以拆分文件之后跑了两个进程，速度减半，380+相当于花费：`380/(3*2)=60min`。这个场景适合很多需要低级人力的地方，可以借助免费额度来赚外快了。

<img src="https://raw.githubusercontent.com/DengSchoo/GayHubImgBed/main/imgs/202312240007209.png" alt="image-20231224000743144" style="zoom: 50%;" />