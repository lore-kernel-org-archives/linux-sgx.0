Return-Path: <SRS0=YPfn=YH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B76C4CECE
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 21:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8C422064A
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 21:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731952AbfJNVft (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Oct 2019 17:35:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:62181 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731408AbfJNVft (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Oct 2019 17:35:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 14:35:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="220224897"
Received: from kridax-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.7.178])
  by fmsmga004.fm.intel.com with ESMTP; 14 Oct 2019 14:35:47 -0700
Date:   Tue, 15 Oct 2019 00:35:46 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 3/7] x86/sgx: Tweak ADD_PAGE ioctl to allow
 adding multiple pages
Message-ID: <20191014213546.GE26869@linux.intel.com>
References: <20191009044241.3591-1-sean.j.christopherson@intel.com>
 <20191009044241.3591-4-sean.j.christopherson@intel.com>
 <20191014213255.GD26869@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014213255.GD26869@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Oct 15, 2019 at 12:32:55AM +0300, Jarkko Sakkinen wrote:
> On Tue, Oct 08, 2019 at 09:42:37PM -0700, Sean Christopherson wrote:
> > Add a nr_pages param to the ioctl for adding pages to the enclave so
> > that userspace can batch multiple pages in a single syscall.  Update the
> > offset, src and nr_pages params prior to returning to userspace so that
> > the caller has sufficient information to analyze failures and can easily
> > restart the ioctl when appropriate.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Please provide a more robust API. Now you decrease the robustness.
> 
> E.g.
> 
> struct sgx_enclave_add_page_desc {
>         __u64   offset;
>         __u16   mrmask;
>         __u8    reserved[6];
> };
> 
> struct sgx_enclave_add_page {
>         __u64   src;
>         __u64   secinfo;
>         __u64   nr_pages;
>         __u64   pages;
> };

If you want to decrease robustness, this would need to be taken as part
of v23 review. It is too big design change to managed like this. I'm
not opionated here. This is just wrong order of doing things.

/Jarkko
