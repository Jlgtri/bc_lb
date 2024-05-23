import type { APIRoute } from 'astro';
import { readdirSync } from 'fs';
import { join, parse } from 'path';
import { CompileFailedError, compileSol } from 'solc-typed-ast';

const CONTRACTS_FOLDER: string = 'contracts';

export const GET: APIRoute = async ({ params }) => {
  if (!params.contract) return new Response(null, { status: 400 });

  const contract: string = params.contract;
  const contractPath = join(CONTRACTS_FOLDER, `${contract}.sol`);
  try {
    const result = await compileSol(contractPath, 'auto');
    return Response.json(
      result.data['contracts'][contractPath][contract]['abi'],
    );
  } catch (e) {
    if (e instanceof CompileFailedError) {
      console.error('Compile errors encountered:');

      for (const failure of e.failures) {
        console.error(`Solc ${failure.compilerVersion}:`);

        for (const error of failure.errors) {
          console.error(error);
        }
      }
    } else {
      console.error((e as Error).message);
    }
    return new Response((e as Error).message, { status: 500 });
  }
};

export function getStaticPaths() {
  return readdirSync(CONTRACTS_FOLDER).map((path) => {
    return {
      params: {
        contract: parse(path).name,
      },
    };
  });
}
