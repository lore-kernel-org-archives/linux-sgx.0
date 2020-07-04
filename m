Return-Path: <SRS0=NOB7=AP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E21C433E2
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Jul 2020 01:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C3B2070B
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Jul 2020 01:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgGDBoD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Jul 2020 21:44:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:14997 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgGDBoD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 3 Jul 2020 21:44:03 -0400
IronPort-SDR: O81FjNfVo/w5IMrx3Yu4VBpBRjMshSxwTg2WqFJ/V1OkMH2WCOPVKq8eq0WfglOCYQoQsF/EXT
 fZXt1F2k5I0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9671"; a="212228146"
X-IronPort-AV: E=Sophos;i="5.75,309,1589266800"; 
   d="scan'208";a="212228146"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2020 18:44:02 -0700
IronPort-SDR: QZOHyOK5kJW9z8mtwu3DQx17NhQgUb+kBoVxaJM9/ph6p57HMbwbPQqRyEA1t7ARHjAvsDDI1w
 dzJehBtI+Baw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,309,1589266800"; 
   d="scan'208";a="296325929"
Received: from itaradex-mobl.ger.corp.intel.com (HELO localhost) ([10.252.52.22])
  by orsmga002.jf.intel.com with ESMTP; 03 Jul 2020 18:43:50 -0700
Date:   Sat, 4 Jul 2020 04:43:49 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
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
Message-ID: <20200704014349.GB129411@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200627174335.GC15585@zn.tnic>
 <20200629152718.GA12312@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629152718.GA12312@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 29, 2020 at 08:27:19AM -0700, Sean Christopherson wrote:
> On Sat, Jun 27, 2020 at 07:43:35PM +0200, Borislav Petkov wrote:
> > On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
> > > +static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
> > > +			 void *token)
> > > +{
> > > +	u64 mrsigner[4];
> > > +	int ret;
> > > +	int i;
> > > +	int j;
> > > +
> > > +	/* Check that the required attributes have been authorized. */
> > > +	if (encl->secs_attributes & ~encl->allowed_attributes)
> > > +		return -EACCES;
> > > +
> > > +	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	mutex_lock(&encl->lock);
> > > +
> > > +	if (atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) {
> > > +		ret = -EFAULT;
> > > +		goto err_out;
> > > +	}
> > 
> > That test should be the first thing this function or its caller does.
> 
> Hmm, I was going to say that SGX_ENCL_INITIALIZED can't be checked until
> encl->lock is held, but that's not true for this path as mutual exclusion
> is provided by the SGX_ENCL_IOCTL flag.  So yeah, this can be checked at
> the same time as SGX_ENCL_CREATED in sgx_ioc_enclave_init().
> 
> > > +	for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
> > > +		for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
> > 
> > Ew, what's that double-loop for?
> > 
> > It tries to init an enclave a bunch of times. Why does it need to init
> > more than once?
> 
> ENCLS[EINIT] is interruptible because it has such a high latency, e.g. 50k+
> cycles on success.  If an IRQ/NMI/SMI becomes pending, EINIT may fail with
> SGX_UNMASKED_EVENT so that the event can be serviced.
> 
> The idea behind the double loop is to try EINIT in a tight loop, then back
> off and sleep for a while before retrying that tight inner loop.
> 
> > > +			ret = sgx_einit(sigstruct, token, encl->secs.epc_page,
> > > +					mrsigner);
> > > +			if (ret == SGX_UNMASKED_EVENT)
> > > +				continue;
> > > +			else
> > > +				break;
> > > +		}
> > > +
> > > +		if (ret != SGX_UNMASKED_EVENT)
> > > +			break;
> > > +
> > > +		msleep_interruptible(SGX_EINIT_SLEEP_TIME);
> > > +
> > > +		if (signal_pending(current)) {
> > > +			ret = -ERESTARTSYS;
> > > +			goto err_out;
> > > +		}
> > > +	}
> > > +
> > > +	if (ret & ENCLS_FAULT_FLAG) {
> > > +		if (encls_failed(ret))
> > > +			ENCLS_WARN(ret, "EINIT");
> > > +
> > > +		sgx_encl_destroy(encl);
> > > +		ret = -EFAULT;
> > > +	} else if (ret) {
> > > +		pr_debug("EINIT returned %d\n", ret);
> > > +		ret = -EPERM;
> > > +	} else {
> > > +		atomic_or(SGX_ENCL_INITIALIZED, &encl->flags);
> > > +	}
> > > +
> > > +err_out:
> > > +	mutex_unlock(&encl->lock);
> > > +	return ret;
> > > +}
> > > +
> > > +/**
> > > + * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
> > > + *
> > > + * @filep:	open file to /dev/sgx
> > 
> > @encl:       pointer to an enclave instance (via ioctl() file pointer)
> > 
> > > + * @arg:	userspace pointer to a struct sgx_enclave_init instance
> > > + *
> > > + * Flush any outstanding enqueued EADD operations and perform EINIT.  The
> > > + * Launch Enclave Public Key Hash MSRs are rewritten as necessary to match
> > > + * the enclave's MRSIGNER, which is caculated from the provided sigstruct.
> > > + *
> > > + * Return:
> > > + *   0 on success,
> > > + *   SGX error code on EINIT failure,
> > > + *   -errno otherwise
> > > + */
> > > +static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
> > > +{
> > > +	struct sgx_sigstruct *sigstruct;
> > > +	struct sgx_enclave_init einit;
> > > +	struct page *initp_page;
> > > +	void *token;
> > > +	int ret;
> > > +
> > > +	if (!(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
> > 
> > Might just as well check the other flags: doing EINIT on an already
> > initialized enclave - SGX_ENCL_INITIALIZED - is perhaps a nono or
> > similarly on a SGX_ENCL_DEAD enclave.
> > 
> > And you could do similar sanity checks in the other ioctl functions.
> 
> Ya, as above, SGX_ENCL_INITIALIZED can be checked here.
> 
> SGX_ENCL_DEAD is actually already checked in in the top level sgx_ioctl(),
> i.e. the check in sgx_encl_add_page() can technically be flat out dropped.
> 
> I say "technically" because I'm a bit torn over SGX_ENCL_DEAD; encl->lock
> must be held to SGX_ENCL_DEAD (the page fault and reclaim flows rely on
> this), but as it stands today only ioctl() paths (guarded by SGX_ENCL_IOCTL)
> and sgx_release() (makes the ioctls() unreachable) set SGX_ENCL_DEAD.
> 
> So it's safe to check SGX_ENCL_DEAD from ioctl() context without holding
> encl->lock, at least in the current code base, but it feels weird/sketchy.
> 
> In the end I don't think I have a strong opinion.  Removing the technically
> unnecessary DEAD check in sgx_encl_add_page() is the simplest change, so it
> may make sense to do that and nothing more for initial upstreaming.  Long
> term, I fully expect we'll add paths that set SGX_ENCL_DEAD outside of
> ioctl() context, e.g. to handle EPC OOM, but it wouldn't be a bad thing to
> have a standalone commit in a future series to add DEAD checks (under
> encl->lock) in the ADD and INIT flows.

AFAIK nonne of th ioctl's should not need SGX_ENCL_DEAD check.

/Jarkko
