const { default : { default : tex2svg } } = await import('node-tikzjax');
import { promises as fsPromises, readFileSync } from 'fs';
import { join } from 'path';

const source = readFileSync('utils/sample.tex', 'utf-8');

const svg = await tex2svg(source, {showConsole: true});

async function asyncWriteFile(filename: string, data: any) {
  /**
   * flags:
   *  - w = Open file for reading and writing. File is created if not exists
   *  - a+ = Open file for reading and appending. The file is created if not exists
   */
  try {
    await fsPromises.writeFile(filename, data, {
      flag: 'w',
    });

    const contents = await fsPromises.readFile(
      filename,
      'utf-8',
    );
    console.log(contents); // 👉️ "One Two Three Four"

    return contents;
  } catch (err) {
    console.log(err);
    return 'Something went wrong';
  }
}

asyncWriteFile('./svgs/tmp.svg', svg)
