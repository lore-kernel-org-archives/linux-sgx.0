Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2CE9C3A5A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 20:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC3D721874
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 20:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389453AbfHWUhK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 16:37:10 -0400
Received: from mga17.intel.com ([192.55.52.151]:46118 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389217AbfHWUhK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 16:37:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 13:37:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="379868105"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 23 Aug 2019 13:37:09 -0700
Date:   Fri, 23 Aug 2019 13:37:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     luto@kernel.org, linux-sgx@vger.kernel.org
Subject: Re: sgx_encl_may_map()
Message-ID: <20190823203709.GA24772@linux.intel.com>
References: <20190823150248.kuxgdxyd4z5wlsz5@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823150248.kuxgdxyd4z5wlsz5@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 23, 2019 at 06:02:48PM +0300, Jarkko Sakkinen wrote:
> Hi
> 
> Couple of remarks that are not reasoned in the code too well:
> 
> 1. Why to allow to mmap() to a range where pages have differing
>    permissions? I think it would be better just to require all
>    pages in a range to have the same permissions.

You mean different vm_max_prot_bits?  I don't think we should deny
mapping a mix of R and RW pages with PROT_READ, e.g. map read-only but
have the option to make select pages writable in the future.

> 2. Why not require exact match with the PROT bits?

Toggling W in particular in the PTEs likely has value, e.g. initialize
data with runtime info and then lock the range in the PTEs.
