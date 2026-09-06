"use client";

import { ErrorEstado } from "@/components/ErrorEstado";

export default function Error(props: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return <ErrorEstado {...props} />;
}
