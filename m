Received: from mga03.intel.com ([134.134.136.65]:15524 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1753534AbeGESVZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Thu, 5
 Jul 2018 14:21:25 -0400
Date: Thu, 5 Jul 2018 21:21:09 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
	<platform-driver-x86@vger.kernel.org>, <dave.hansen@intel.com>,
	<sean.j.christopherson@intel.com>, <nhorman@redhat.com>,
	<npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>, Ingo Molnar
	<mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "open list:X86
 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 09/13] x86/sgx: EPC page allocation routines
Message-ID: <20180705182109.GA5353@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
 <20180703182118.15024-10-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.21.1807032216390.1816@nanos.tec.linutronix.de>
 <20180704042516.GA20409@zn.tnic>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180704042516.GA20409@zn.tnic>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Wed, Jul 04, 2018 at 06:25:53AM +0200, Borislav Petkov wrote:
> ... and also, why are the other exports not EXPORT_SYMBOL_GPL?

I think they could just as well be that. No reason to use
EXPORT_SYMBOL() even if the source files are dual licensed.

/Jarkko
