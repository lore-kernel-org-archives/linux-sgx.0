From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "David S. Miller"
	<davem@davemloft.net>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Linus Walleij <linus.walleij@linaro.org>,
	"Randy Dunlap" <rdunlap@infradead.org>, open list
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v12 01/13] x86/sgx: updated MAINTAINERS
Date: Tue, 3 Jul 2018 21:19:46 +0300
Message-ID: <20180703182118.15024-2-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

Updated the MAINTAINERS file to point to the Intel SGX subsystem tree.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ca4afd68530c..12f7c68378e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7329,6 +7329,13 @@ L:	linux-gpio@vger.kernel.org
 S:	Maintained
 F:	drivers/gpio/gpio-intel-mid.c
 
+INTEL SGX
+M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+L:	linux-sgx@vger.kernel.org
+Q:	https://patchwork.kernel.org/project/intel-sgx/list/
+F:	drivers/platform/x86/intel_sgx/
+K:	\bSGX_
+
 INVENSENSE MPU-3050 GYROSCOPE DRIVER
 M:	Linus Walleij <linus.walleij@linaro.org>
 L:	linux-iio@vger.kernel.org
-- 
2.17.1
