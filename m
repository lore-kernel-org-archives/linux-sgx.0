Return-Path: <SRS0=s70M=YA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2E5ECE58D
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Oct 2019 14:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DFB521721
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Oct 2019 14:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbfJGOuO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Oct 2019 10:50:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:35088 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbfJGOuN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 7 Oct 2019 10:50:13 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 07:50:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,268,1566889200"; 
   d="scan'208";a="192297760"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 07 Oct 2019 07:50:12 -0700
Date:   Mon, 7 Oct 2019 07:50:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com
Subject: Re: [PATCH v22 09/24] x86/sgx: Add functions to allocate and free
 EPC pages
Message-ID: <20191007145011.GA18016@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-10-jarkko.sakkinen@linux.intel.com>
 <20191005164408.GB25699@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191005164408.GB25699@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 05, 2019 at 06:44:08PM +0200, Borislav Petkov wrote:
> On Tue, Sep 03, 2019 at 05:26:40PM +0300, Jarkko Sakkinen wrote:
> > +/**
> > + * __sgx_free_page - Free an EPC page
> > + * @page:	pointer a previously allocated EPC page
> > + *
> > + * EREMOVE an EPC page and insert it back to the list of free pages.
> > + *
> > + * Return:
> > + *   0 on success
> > + *   SGX error code if EREMOVE fails
> > + */
> > +int __sgx_free_page(struct sgx_epc_page *page)
> > +{
> > +	struct sgx_epc_section *section = sgx_epc_section(page);
> > +	int ret;
> 
> Shouldn't you be grabbing the lock here already?
> 
> Or nothing can happen to that page from another thread after you
> ENCLS[EREMOVE] it and before it is added to the ->page_list of the
> section?

The caller is responsible for ensuring EREMOVE can be safely executed,
e.g. by holding the enclave's lock.

For many ENCLS leafs, EREMOVE included, the CPU requires exclusive access
to the SGX Enclave Control Structures (SECS)[*] and will signal a #GP if
a different logical CPU is already executing an ENCLS leaf that requires
exclusive SECS access.  The SGX subsystem uses a per-enclave mutex to
serialize such ENCLS leafs, among other things.

[*] The SECS is a per-enclave page that resides in the EPC and can only be
    directly accessed by the CPU.  It's used to track metadata about the
    enclave, e.g. number of child pages, base, size, etc...

> > +
> > +	ret = __eremove(sgx_epc_addr(page));
> > +	if (ret)
> > +		return ret;
> > +
> > +	spin_lock(&section->lock);
> > +	list_add_tail(&page->list, &section->page_list);
> > +	section->free_cnt++;
> > +	spin_unlock(&section->lock);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(__sgx_free_page);
> > +
> > +/**
> > + * sgx_free_page - Free an EPC page and WARN on failure
> > + * @page:	pointer to a previously allocated EPC page
> > + *
> > + * EREMOVE an EPC page and insert it back to the list of free pages, and WARN
> > + * if EREMOVE fails.  For use when the call site cannot (or chooses not to)
> > + * handle failure, i.e. the page is leaked on failure.
> > + */
> > +void sgx_free_page(struct sgx_epc_page *page)
> > +{
> > +	int ret;
> > +
> > +	ret = __sgx_free_page(page);
> > +	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);
> 
> That will potentially flood dmesg. Why are we even accommodating such
> callers? They either handle the error or they don't get to alloc EPC
> pages. There's also __must_check with which you can enforce the error
> code checking or we simply don't allow not handling failure. Fullstop.

It was deliberately left as a WARN as having multiple stack traces has
been very helpful for triaging and debugging software bugs.  I agree that
it can and should be changed to a WARN_ONCE() for upstream.

As for why it exists at all, the WARN will only fire if there is a kernel
and/or CPU bug.  In the vast majority of cases, EREMOVE is guaranteed to
be successful (assuming no bugs).  In those situations, if EREMOVE fails
there really isn't a sane option other to WARN and leak the page, e.g.
the kernel can't override the CPUs protection to forcefully EREMOVE the
page.

The non-warn variant, __sgx_free_page(), is provided for the (currently)
one case where EREMOVE failure is expected/tolerable (opportunstically
freeing EPC pages when the enclave is killed).
