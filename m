Return-Path: <SRS0=kvvX=WP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66025C3A5A0
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Aug 2019 17:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37E1922CEB
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Aug 2019 17:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfHSRyX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Aug 2019 13:54:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:3032 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbfHSRyW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Aug 2019 13:54:22 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 10:54:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="172197732"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 19 Aug 2019 10:54:21 -0700
Date:   Mon, 19 Aug 2019 10:54:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: mmap(), #PF handler and EADD interaction
Message-ID: <20190819175420.GA1916@linux.intel.com>
References: <20190819152431.x5ajhd67cpqag5ue@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819152431.x5ajhd67cpqag5ue@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 19, 2019 at 06:24:31PM +0300, Jarkko Sakkinen wrote:
> I did some backtracking today how the permission flow worked.
> 
> With the maximum VM flags defined for a page, what if EADD is done after
> mmap()?  E.g. we first do mmap() with RWX and later EADD with lets say
> RW.

sgx_encl_may_map() returns -EACCESS on any attempt to mmap()/mprotect() a
range that is not fully covered by EADD'd pages with any of PROT_READ,
PROT_WRITE or PROT_EXEC.  This is handled in the !page check below.

	if (!page || (~page->vm_prot_bits & vm_prot_bits))
		return -EACCES;

A waiver is given for PROT_NONE, primarily so that mmap() can be used
prior to ECREATE to find an available ELRANGE, but any attempt to access
a PROT_NONE VMA will result in a SIGSEGV, e.g. access_error() explicitly
checks the RWX prot bits.

	/* PROT_NONE always succeeds. */
	if (!vm_prot_bits)
		return 0;


> 
> The first thing that comes to mind is that the #PF handler should caught
> this corner case.
> 
> Now the code correctly validates when you do either mmap() and
> mprotect() after EADD(s) but I think "other way around" is missing.
> 
> /Jarkko
