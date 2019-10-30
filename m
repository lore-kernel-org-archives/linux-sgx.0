Return-Path: <SRS0=btYB=YX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A04CA9EC7
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Oct 2019 09:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02BFF20874
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Oct 2019 09:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfJ3Jar (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Oct 2019 05:30:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:4690 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfJ3Jar (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Oct 2019 05:30:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 02:30:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,247,1569308400"; 
   d="scan'208";a="198625928"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 30 Oct 2019 02:30:45 -0700
Date:   Wed, 30 Oct 2019 02:30:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v23 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191030093045.GB12481@linux.intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
 <20191029092920.GA14494@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029092920.GA14494@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 29, 2019 at 11:29:20AM +0200, Jarkko Sakkinen wrote:
> On Mon, Oct 28, 2019 at 11:03:12PM +0200, Jarkko Sakkinen wrote:
> > +/**
> > + * sgx_ioc_enclave_add_pages() - The handler for %SGX_IOC_ENCLAVE_ADD_PAGES
> > + * @encl:       pointer to an enclave instance (via ioctl() file pointer)
> > + * @arg:	a user pointer to a struct sgx_enclave_add_pages instance
> > + *
> > + * Add (EADD) one or more pages to an uninitialized enclave, and optionally
> > + * extend (EEXTEND) the measurement with the contents of the page. The range of
> > + * pages must be virtually contiguous. The SECINFO and measurement mask are
> > + * applied to all pages, i.e. pages with different properties must be added in
> > + * separate calls.
> > + *
> > + * A SECINFO for a TCS is required to always contain zero permissions because
> > + * CPU silently zeros them. Allowing anything else would cause a mismatch in
> > + * the measurement.
> > + *
> > + * mmap()'s protection bits are capped by the page permissions. For each page
> > + * address, the maximum protection bits are computed with the following
> > + * heuristics:
> > + *
> > + * 1. A regular page: PROT_R, PROT_W and PROT_X match the SECINFO permissions.
> > + * 2. A TCS page: PROT_R | PROT_W.
> > + * 3. No page: PROT_NONE.
> > + *
> > + * mmap() is not allowed to surpass the minimum of the maximum protection bits
> > + * within the given address range.
> > + *
> > + * As stated above, a non-existent page is interpreted as a page with no
> > + * permissions. In effect, this allows mmap() with PROT_NONE to be used to seek
> > + * an address range for the enclave that can be then populated into SECS.
> > + *
> > + * @arg->addr, @arg->src and @arg->length are adjusted to reflect the
> > + * remaining pages that need to be added to the enclave, e.g. userspace can
> > + * re-invoke SGX_IOC_ENCLAVE_ADD_PAGES using the same struct in response to an
> > + * ERESTARTSYS error.
> > + *
> > + * Return:
> > + *   0 on success,
> > + *   -EINVAL if any input param or the SECINFO contains invalid data,
> > + *   -EACCES if an executable source page is located in a noexec partition,
> > + *   -ENOMEM if any memory allocation, including EPC, fails,
> > + *   -ERESTARTSYS if a pending signal is recognized
> > + */
> > +static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
> 
> This should return the number of pages processed instead of zero on
> success. Kernel needs to be able to cap the amount it will process.

Why?  The number of pages processed is effectively returned via the params
on any error, e.g. wouldn't it be more appropriate to return -ERESTARTSYS?
And I don't see any reason to add an arbitrary cap on the number of pages,
e.g. SGX plays nice with the scheduler and signals, and restricting the
number of EPC pages available to a process via cgroups (returning -ENOMEM)
is a better solution for managing EPC.
