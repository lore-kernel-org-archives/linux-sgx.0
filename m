Return-Path: <SRS0=sWWJ=7K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08896C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 19:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7BE3206A1
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 19:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406109AbgE1THe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 May 2020 15:07:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:13720 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406118AbgE1THc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 May 2020 15:07:32 -0400
IronPort-SDR: EH3QLrK9f0B9TqFHFHT8B9ECEeaJ86fBfYsjH3yZjuRM1g1N3RUVA15eAwHQhbTPWDpvm3k69N
 M6lQLrWwoKlQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 12:07:31 -0700
IronPort-SDR: c2+n63ZwHY+qgdjCq+YtpiNCWzaPGq5MxEgaU8pCPicDaCtnhMkFp8GhaRLiY3YQd847BNFQG8
 Ka9t5ZR4ziiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,445,1583222400"; 
   d="scan'208";a="443080722"
Received: from jtitox-mobl.ger.corp.intel.com (HELO localhost) ([10.252.56.171])
  by orsmga005.jf.intel.com with ESMTP; 28 May 2020 12:07:22 -0700
Date:   Thu, 28 May 2020 22:07:18 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 08/20] x86/sgx: Add functions to allocate and free
 EPC pages
Message-ID: <20200528190718.GA2147934@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-9-jarkko.sakkinen@linux.intel.com>
 <20200526125207.GE28228@zn.tnic>
 <20200527042111.GI31696@linux.intel.com>
 <20200527204638.GG1721@zn.tnic>
 <20200528012319.GA7577@linux.intel.com>
 <20200528013617.GD25962@linux.intel.com>
 <20200528065223.GB188849@linux.intel.com>
 <20200528171635.GB382@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528171635.GB382@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 28, 2020 at 07:16:35PM +0200, Borislav Petkov wrote:
> Lemme reply to all mails with one. :-)
> 
> I think Sean almost had it:
> 
> >  sgx_alloc_epc_section -> sgx_map_epc_section
> >  sgx_free_epc_section  -> sgx_unmap_epc_section
> 
> Or even
> 
>   sgx_setup_epc_section()
>   sgx_free_epc_section()

I like these. Lets lock in.

> And except those last two. Those are allocating a page from the EPC
> sections so I'd call them:
> 
> sgx_try_alloc_page    -> sgx_alloc_epc_page_section
> __sgx_try_alloc_page  -> __sgx_alloc_epc_page_section
> 
> former doing the loop, latter doing the per-section list games.

sgx_alloc_epc_page_section() is a bit nasty and long name to use for
grabbing a page. And even the documentation spoke about grabbing before
this naming discussion. I think it is a great description what is going
on.  Everytime I talk about the subject I talk about grabbing.

Lets just say that your suggestion, I could not use in a conference
talk as a verb when I describe what is going on. That function
signature does not fit to my mouth :-) I would talk about
grabbing a page.

This how I refactored yesterday (is in my GIT tree already):

/**
 * sgx_grab_page() - Grab a free EPC page
 * @owner:	the owner of the EPC page
 * @reclaim:	reclaim pages if necessary
 *
 * Iterate through EPC sections and borrow a free EPC page to the caller. When a
 * page is no longer needed it must be released with sgx_free_page(). If
 * @reclaim is set to true, directly reclaim pages when we are out of pages. No
 * mm's can be locked when @reclaim is set to true.
 *
 * Finally, wake up ksgxswapd when the number of pages goes below the watermark
 * before returning back to the caller.
 *
 * Return:
 *   an EPC page,
 *   -errno on error
 */

I also rewrote the kdoc.

I do agree that sgx_try_grab_page() should be renamed as __sgx_grab_page().

/Jarkko
