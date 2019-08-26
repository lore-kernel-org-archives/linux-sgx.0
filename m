Return-Path: <SRS0=p0kK=WW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124C3C3A5A1
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 02:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7BB1206BB
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 02:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbfHZC4U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 25 Aug 2019 22:56:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:51566 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729206AbfHZC4U (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 25 Aug 2019 22:56:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Aug 2019 19:56:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="204412572"
Received: from donga-mobl.ger.corp.intel.com (HELO localhost) ([10.249.34.235])
  by fmsmga004.fm.intel.com with ESMTP; 25 Aug 2019 19:56:18 -0700
Date:   Mon, 26 Aug 2019 05:56:16 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     luto@kernel.org, linux-sgx@vger.kernel.org
Subject: Re: sgx_encl_may_map()
Message-ID: <20190826025616.7qvbggzvk7grq6h6@linux.intel.com>
References: <20190823150248.kuxgdxyd4z5wlsz5@linux.intel.com>
 <20190823203709.GA24772@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823203709.GA24772@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 23, 2019 at 01:37:09PM -0700, Sean Christopherson wrote:
> On Fri, Aug 23, 2019 at 06:02:48PM +0300, Jarkko Sakkinen wrote:
> > Hi
> > 
> > Couple of remarks that are not reasoned in the code too well:
> > 
> > 1. Why to allow to mmap() to a range where pages have differing
> >    permissions? I think it would be better just to require all
> >    pages in a range to have the same permissions.
> 
> You mean different vm_max_prot_bits?  I don't think we should deny
> mapping a mix of R and RW pages with PROT_READ, e.g. map read-only but
> have the option to make select pages writable in the future.
> 
> > 2. Why not require exact match with the PROT bits?
> 
> Toggling W in particular in the PTEs likely has value, e.g. initialize
> data with runtime info and then lock the range in the PTEs.

Thanks.

This is really important to document. I'll send a kdoc update for the
ioctl.

/Jarkko
