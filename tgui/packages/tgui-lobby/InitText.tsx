export type InitTextData = {
  title: string;
  lines: string[];
};

export function InitText({
  text,
  faded,
}: {
  text: InitTextData;
  faded: boolean;
}) {
  return (
    <div
      className={`lobby__init-text ${faded ? 'lobby__init-text--faded' : ''}`}
    >
      <div
        className="lobby__init-text-title"
        dangerouslySetInnerHTML={{ __html: text.title }}
      />
      {text.lines.map((line, index) => (
        <div key={index} dangerouslySetInnerHTML={{ __html: line }} />
      ))}
    </div>
  );
}
