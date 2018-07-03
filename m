Date: Tue, 3 Jul 2018 20:41:25 +0200
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
CC: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab
	<mchehab+samsung@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, Linus Walleij
	<linus.walleij@linaro.org>, Randy Dunlap <rdunlap@infradead.org>, open list
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 01/13] x86/sgx: updated MAINTAINERS
In-Reply-To: <20180703182118.15024-2-jarkko.sakkinen@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1807032038470.1816@nanos.tec.linutronix.de>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com> <20180703182118.15024-2-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="US-ASCII"
Return-Path: tglx@linutronix.de
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

On Tue, 3 Jul 2018, Jarkko Sakkinen wrote:

> Updated the MAINTAINERS file to point to the Intel SGX subsystem tree.

Update not Updated. Documentation says:

  Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour.

Applies to later patches as well.

Thanks,

	tglx
