Received: from mga01.intel.com ([192.55.52.88]:64265 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1726705AbeKCIXL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Sat, 3
 Nov 2018 04:23:11 -0400
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, <andriy.shevchenko@linux.intel.com>, "Jarkko
 Sakkinen" <jarkko.sakkinen@linux.intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Mauro Carvalho Chehab
	<mchehab+samsung@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	"Andrew Morton" <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
	open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v15 01/23] x86/sgx: Update MAINTAINERS
Date: Sat, 3 Nov 2018 01:11:00 +0200
Message-ID: <20181102231320.29164-2-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Content-Type: text/plain
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

Add the maintainer information for the SGX subsystem.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 02a39617ec82..a5597a89c7a9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7595,6 +7595,13 @@ L:	linux-gpio@vger.kernel.org
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
2.19.1
