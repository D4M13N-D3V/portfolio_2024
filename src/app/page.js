// app/page.js
'use client';

import { useEffect, useState } from 'react';
import { 
  Box, 
  Typography, 
  Container, 
  CircularProgress,
  Fade,
  ThemeProvider,
  createTheme,
  CssBaseline
} from '@mui/material';

// Create a custom theme with a dark mode and custom colors
const theme = createTheme({
  palette: {
    mode: 'dark',
    primary: {
      main: '#90caf9',
    },
    background: {
      default: '#001E3C',
      paper: '#0A1929',
    },
  },
  typography: {
    fontFamily: '"Roboto", "Helvetica", "Arial", sans-serif',
    h1: {
      fontSize: '4rem',
      fontWeight: 700,
      letterSpacing: '-0.01562em',
    },
    h2: {
      fontSize: '2.5rem',
      fontWeight: 400,
      letterSpacing: '-0.00833em',
    },
  },
});

export default function ComingSoon() {
  // State to manage loading and content visibility
  const [isLoading, setIsLoading] = useState(true);
  const [showMainContent, setShowMainContent] = useState(false);

  useEffect(() => {
    // Initial loading animation timer
    const timer = setTimeout(() => {
      setIsLoading(false);
    }, 2000);

    // Delay before showing main content
    const contentTimer = setTimeout(() => {
      setShowMainContent(true);
    }, 2500);

    // Cleanup timers on component unmount
    return () => {
      clearTimeout(timer);
      clearTimeout(contentTimer);
    };
  }, []);

  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Container>
        <Box
          sx={{
            minHeight: '100vh',
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'center',
            alignItems: 'center',
            textAlign: 'center',
            gap: 4,
          }}
        >
          {isLoading ? (
            <Fade in={true} timeout={1000}>
              <CircularProgress size={60} />
            </Fade>
          ) : (
            <>
              <Fade in={showMainContent} timeout={1000}>
                <Typography
                  variant="h1"
                  component="h1"
                  sx={{
                    background: 'linear-gradient(45deg, #90caf9 30%, #4fc3f7 90%)',
                    backgroundClip: 'text',
                    WebkitBackgroundClip: 'text',
                    color: 'transparent',
                    mb: 2,
                  }}
                >
                  Coming Soon
                </Typography>
              </Fade>
              <Fade in={showMainContent} timeout={1500}>
                <Typography
                  variant="h2"
                  color="text.secondary"
                  sx={{ maxWidth: '600px' }}
                >
                  Something amazing is in the works. Stay tuned!
                </Typography>
              </Fade>
            </>
          )}
        </Box>
      </Container>
    </ThemeProvider>
  );
}