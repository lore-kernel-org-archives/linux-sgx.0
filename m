Received: from mga02.intel.com ([134.134.136.20]:17322 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1729800AbeKFCwi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Mon, 5
 Nov 2018 21:52:38 -0500
Date: Mon, 5 Nov 2018 19:31:44 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jethro Beekman <jethro@fortanix.com>
CC: "x86@kernel.org" <x86@kernel.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, "dave.hansen@intel.com" <dave.hansen@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"nhorman@redhat.com" <nhorman@redhat.com>, "npmccallum@redhat.com"
	<npmccallum@redhat.com>, "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
	"shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
	"haitao.huang@intel.com" <haitao.huang@intel.com>, "mark.shanahan@intel.com"
	<mark.shanahan@intel.com>, "andriy.shevchenko@linux.intel.com"
	<andriy.shevchenko@linux.intel.com>, Suresh Siddha
	<suresh.b.siddha@intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, Reinette Chatre <reinette.chatre@intel.com>, "Rafael J.
 Wysocki" <rafael.j.wysocki@intel.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 16/23] x86/sgx: Enumerate and track EPC sections
Message-ID: <20181105173144.GE4502@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-17-jarkko.sakkinen@linux.intel.com>
 <79867568-c21f-8a09-d06e-360b1b925dd5@fortanix.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <79867568-c21f-8a09-d06e-360b1b925dd5@fortanix.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Sat, Nov 03, 2018 at 01:07:27AM +0000, Jethro Beekman wrote:
> > +	for (i = 0; i < SGX_MAX_EPC_SECTIONS; i++) {
> 
> Perhaps print a warning if there are more than SGX_MAX_EPC_SECTIONS sections
> reported by CPUID.

Makes sense. I'll add it.

/Jarkko
