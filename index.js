// Exposes the on-disk path of the schema library so consumers can read
// `.schema.odin` files directly without resolving relative paths themselves.

import { fileURLToPath } from 'node:url';
import { dirname } from 'node:path';

/** Absolute path to the directory containing this package's `.schema.odin` files. */
export const schemasRoot = dirname(fileURLToPath(import.meta.url));
