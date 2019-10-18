Return-Path: <SRS0=5L1B=YL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02228CA9EA0
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 13:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D525C222C5
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Oct 2019 13:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408337AbfJRNNp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Oct 2019 09:13:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:46667 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729109AbfJRNNp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Oct 2019 09:13:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 06:13:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,311,1566889200"; 
   d="scan'208";a="221737534"
Received: from jlenoir-mobl.ger.corp.intel.com (HELO localhost) ([10.252.2.252])
  by fmsmga004.fm.intel.com with ESMTP; 18 Oct 2019 06:13:43 -0700
Date:   Fri, 18 Oct 2019 16:13:42 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 00/12] x86/sgx: Bug fixes for v23
Message-ID: <20191018131342.GA30911@linux.intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
 <20191017181054.GH6667@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017181054.GH6667@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 17, 2019 at 09:10:54PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 16, 2019 at 11:37:33AM -0700, Sean Christopherson wrote:
> > As requested, the merge of the EPC and EADD bug fix series.  The headliners
> > are two critical bug fixes for a memory leak in sgx_encl_destroy() and a
> > livelock due to the EPC page free count getting corrupted.
> 
> BTW, are you still planning to send multi-page EADD? I think it should
> be done. It is obviously superior design when combined with my small
> twist where mrmask is calculated inside the kernel.
> 
> Not only does it provide multi-page EADD but you could always do one
> ioctl per area. With mrmask in parameters you end up needing two if the
> user space is designed in a way that measurement is not a multiple of a
> page.
> 
> If mrmask would make sense in the parameters, then a single-page EADD
> would be cool but I think we want to render it out completely.

I applied the fixes that I saw were appropriate. You can check if
this has been sufficient and send a revised set of fixes if not.

/Jarkko
