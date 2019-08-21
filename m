Return-Path: <SRS0=WfLj=WR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89852C3A59E
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Aug 2019 18:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6587920679
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Aug 2019 18:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfHUSPr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 14:15:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:17839 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbfHUSPr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 14:15:47 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 11:15:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="378231167"
Received: from kumarsh1-mobl.ger.corp.intel.com (HELO localhost) ([10.249.33.104])
  by fmsmga005.fm.intel.com with ESMTP; 21 Aug 2019 11:15:44 -0700
Date:   Wed, 21 Aug 2019 21:15:43 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: mmap(), #PF handler and EADD interaction
Message-ID: <20190821181543.uwvtlcoh2t5nb6ta@linux.intel.com>
References: <20190819152431.x5ajhd67cpqag5ue@linux.intel.com>
 <20190819175420.GA1916@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819175420.GA1916@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 19, 2019 at 10:54:21AM -0700, Sean Christopherson wrote:
> On Mon, Aug 19, 2019 at 06:24:31PM +0300, Jarkko Sakkinen wrote:
> > I did some backtracking today how the permission flow worked.
> > 
> > With the maximum VM flags defined for a page, what if EADD is done after
> > mmap()?  E.g. we first do mmap() with RWX and later EADD with lets say
> > RW.
> 
> sgx_encl_may_map() returns -EACCESS on any attempt to mmap()/mprotect() a
> range that is not fully covered by EADD'd pages with any of PROT_READ,
> PROT_WRITE or PROT_EXEC.  This is handled in the !page check below.

Aah so it was. Can you send me a patch to extend the kdoc with
additional paragraph to remark this?

/Jarkko
