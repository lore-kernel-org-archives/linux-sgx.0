Return-Path: <SRS0=NOB7=AP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50492C433E0
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Jul 2020 01:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F82C20771
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Jul 2020 01:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgGDBmn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Jul 2020 21:42:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:27633 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgGDBmm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 3 Jul 2020 21:42:42 -0400
IronPort-SDR: URsA/gpr1+psg0qGkyyLypn69DRDzAwGUhoegrqJ+QOKT2P4lvbauetVkR60TiqrkvGcA4k2b9
 uv90dBVsqPcg==
X-IronPort-AV: E=McAfee;i="6000,8403,9671"; a="127304430"
X-IronPort-AV: E=Sophos;i="5.75,309,1589266800"; 
   d="scan'208";a="127304430"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2020 18:42:41 -0700
IronPort-SDR: Tlv4/bc43PDV98bFLyN78rNhcEqaX5HK7KbatAVa5KBJbcVIZD8nHXpSFk/42Hvb52Q0iJ863q
 gaDyiTY0HOyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,309,1589266800"; 
   d="scan'208";a="266063928"
Received: from itaradex-mobl.ger.corp.intel.com (HELO localhost) ([10.252.52.22])
  by fmsmga007.fm.intel.com with ESMTP; 03 Jul 2020 18:42:26 -0700
Date:   Sat, 4 Jul 2020 04:42:24 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200704014224.GA129411@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200627174335.GC15585@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200627174335.GC15585@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Jun 27, 2020 at 07:43:35PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
> > +static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
> > +			 void *token)
> > +{
> > +	u64 mrsigner[4];
> > +	int ret;
> > +	int i;
> > +	int j;
> > +
> > +	/* Check that the required attributes have been authorized. */
> > +	if (encl->secs_attributes & ~encl->allowed_attributes)
> > +		return -EACCES;
> > +
> > +	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
> > +	if (ret)
> > +		return ret;
> > +
> > +	mutex_lock(&encl->lock);
> > +
> > +	if (atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) {
> > +		ret = -EFAULT;
> > +		goto err_out;
> > +	}
> 
> That test should be the first thing this function or its caller does.

Fixed.

> 
> > +	for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
> > +		for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
> 
> Ew, what's that double-loop for?
> 
> It tries to init an enclave a bunch of times. Why does it need to init
> more than once?

From SDM:

"Periodically, EINIT polls for certain asynchronous events. If such an
event is detected, it completes with failure code (ZF=1 and RAX =
SGX_UNMASKED_EVENT), and RIP is incremented to point to the next
instruction. These events includes external interrupts, non-maskable
interrupts, system-management interrupts, machine checks, INIT signals,
and the VMX-preemption timer. EINIT does not fail if the pending event
is inhibited (e.g., external interrupts could be inhibited due to
blocking by MOV SS blocking or by STI)."

Not exactly sure though why this must be polled inside the kernel though.

> 
> > +			ret = sgx_einit(sigstruct, token, encl->secs.epc_page,
> > +					mrsigner);
> > +			if (ret == SGX_UNMASKED_EVENT)
> > +				continue;
> > +			else
> > +				break;
> > +		}
> > +
> > +		if (ret != SGX_UNMASKED_EVENT)
> > +			break;
> > +
> > +		msleep_interruptible(SGX_EINIT_SLEEP_TIME);
> > +
> > +		if (signal_pending(current)) {
> > +			ret = -ERESTARTSYS;
> > +			goto err_out;
> > +		}
> > +	}
> > +
> > +	if (ret & ENCLS_FAULT_FLAG) {
> > +		if (encls_failed(ret))
> > +			ENCLS_WARN(ret, "EINIT");
> > +
> > +		sgx_encl_destroy(encl);
> > +		ret = -EFAULT;
> > +	} else if (ret) {
> > +		pr_debug("EINIT returned %d\n", ret);
> > +		ret = -EPERM;
> > +	} else {
> > +		atomic_or(SGX_ENCL_INITIALIZED, &encl->flags);
> > +	}
> > +
> > +err_out:
> > +	mutex_unlock(&encl->lock);
> > +	return ret;
> > +}
> > +
> > +/**
> > + * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
> > + *
> > + * @filep:	open file to /dev/sgx
> 
> @encl:       pointer to an enclave instance (via ioctl() file pointer)
> 
> > + * @arg:	userspace pointer to a struct sgx_enclave_init instance
> > + *
> > + * Flush any outstanding enqueued EADD operations and perform EINIT.  The
> > + * Launch Enclave Public Key Hash MSRs are rewritten as necessary to match
> > + * the enclave's MRSIGNER, which is caculated from the provided sigstruct.
> > + *
> > + * Return:
> > + *   0 on success,
> > + *   SGX error code on EINIT failure,
> > + *   -errno otherwise
> > + */
> > +static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
> > +{
> > +	struct sgx_sigstruct *sigstruct;
> > +	struct sgx_enclave_init einit;
> > +	struct page *initp_page;
> > +	void *token;
> > +	int ret;
> > +
> > +	if (!(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
> 
> Might just as well check the other flags: doing EINIT on an already
> initialized enclave - SGX_ENCL_INITIALIZED - is perhaps a nono or
> similarly on a SGX_ENCL_DEAD enclave.
> 
> And you could do similar sanity checks in the other ioctl functions.

Agreed (see my earlier response, let's continue this discussion there).

/Jarkko
