import type React from 'react'

export function LogoP1(props: React.SVGAttributes<SVGSVGElement>) {
  return (
    <svg
      viewBox="0 0 256 256"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      {...props}>
      {/* Background circle */}
      <g>
        <path
          d="M128 8 A120 120 0 1 1 128 248 A120 120 0 1 1 128 8 Z"
          fill="transparent"
          stroke="white"
          strokeWidth="4"
        />

        {/* Stylized P */}
        <path
          d="M60 80 L60 200 L80 200 L80 150 L120 150 C140 150 156 134 156 114 C156 94 140 80 120 80 L60 80 Z M80 100 L120 100 C129 100 136 107 136 114 C136 121 129 130 120 130 L80 130 L80 100 Z"
          fill="white"
        />

        {/* Stylized 1 */}
        <rect x="180" y="80" width="20" height="120" fill="white" />
        <rect x="160" y="80" width="40" height="20" fill="white" />

        {/* Accent element */}
        <path
          d="M200 84 A6 6 0 1 1 200 96 A6 6 0 1 1 200 84 Z"
          fill="#01AAEE"
        />
      </g>
    </svg>
  )
}