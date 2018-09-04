Received: from mga01.intel.com ([192.55.52.88]:16423 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S1727223AbeIDT4F (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 4
 Sep 2018 15:56:05 -0400
Date: Tue, 4 Sep 2018 18:30:21 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"nhorman@redhat.com" <nhorman@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>, "Ayoun, Serge"
	<serge.ayoun@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"npmccallum@redhat.com" <npmccallum@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: [PATCH v13 10/13] x86/sgx: Add sgx_einit() for initializing
 enclaves
Message-ID: <20180904153021.GB8344@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
 <20180827185507.17087-11-jarkko.sakkinen@linux.intel.com>
 <1535406078.3416.9.camel@intel.com>
 <20180828070129.GA5301@linux.intel.com>
 <105F7BF4D0229846AF094488D65A09893541037C@PGSMSX112.gar.corp.intel.com>
 <20180831121645.GA18075@linux.intel.com>
 <20180831181509.GB21555@linux.intel.com>
 <20180903191926.GC13497@linux.intel.com>
 <105F7BF4D0229846AF094488D65A09893541970F@PGSMSX112.gar.corp.intel.com>
 <20180904145451.GA5233@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180904145451.GA5233@linux.intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

On Tue, Sep 04, 2018 at 07:54:51AM -0700, Sean Christopherson wrote:
> I don't see any value in trying to rule out specific causes of
> INVALID_TOKEN, but we should only retry EINIT if ret==INVALID_TOKEN
> and RDMSR(HASH0) != sgx_lepubkeyhash[0].  Only the first MSR needs to
> be checked for validity as they're a package deal, i.e. they'll all be
> valid or all be reset.  There shouldn't be a limit on retry attempts,
> e.g. the MSRs could theoretically be reset between WRMSR and EINIT.

Why is doing rdmsrs necessary? With the INVALID_TOKEN error we know we
are out-of-sync i.e. have been sleeping and then one just needs to do
wrmsrs.

I think one retry should be enough given that VMM traps EINIT. One retry
is needed to take care of the guest itself (or host if we are running on
bare metal) having been in a sleep state.

/Jarkko
