Return-Path: <SRS0=c2s8=RV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8005C43381
	for <linux-sgx@archiver.kernel.org>; Mon, 18 Mar 2019 19:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DD532173C
	for <linux-sgx@archiver.kernel.org>; Mon, 18 Mar 2019 19:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfCRTxo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:53:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:35369 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbfCRTxo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 18 Mar 2019 15:53:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Mar 2019 12:53:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,494,1544515200"; 
   d="scan'208";a="156115274"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga001.fm.intel.com with ESMTP; 18 Mar 2019 12:53:43 -0700
Date:   Mon, 18 Mar 2019 12:53:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v19 07/27] x86/mm: x86/sgx: Signal SIGSEGV for userspace
 #PFs w/ PF_SGX
Message-ID: <20190318195342.GB20298@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-8-jarkko.sakkinen@linux.intel.com>
 <25682442-e244-7308-e805-9e4960b7b525@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25682442-e244-7308-e805-9e4960b7b525@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 18, 2019 at 10:15:18AM -0700, Dave Hansen wrote:
> On 3/17/19 2:14 PM, Jarkko Sakkinen wrote:
> > +	/*
> > +	 * Access is blocked by the Enclave Page Cache Map (EPCM), i.e. the
> > +	 * access is allowed by the PTE but not the EPCM.  This usually happens
> > +	 * when the EPCM is yanked out from under us, e.g. by hardware after a
> > +	 * suspend/resume cycle.  In any case, software, i.e. the kernel, can't
> > +	 * fix the source of the fault as the EPCM can't be directly modified
> > +	 * by software.  Handle the fault as an access error in order to signal
> > +	 * userspace, e.g. so that userspace can rebuild their enclave(s), even
> > +	 * though userspace may not have actually violated access permissions.
> > +	 */
> > +	if (unlikely(error_code & X86_PF_SGX))
> > +		return 1;
> 
> A sanitized error_code gets passed up to userspace.  Is that how
> userspace figures out that this was a PF_SGX fault instead of something
> more routine?

Yes.  Technically userspace can survive without PF_SGX, e.g. assume that
SIGSEGV on EENTER itself indicates an EPCM fault, but the explicit flag
does make things easier and cleaner.
