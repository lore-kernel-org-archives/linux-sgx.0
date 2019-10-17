Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F41ECE58E
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 18:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA89D21835
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 18:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437946AbfJQSME (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Oct 2019 14:12:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:10401 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395229AbfJQSME (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 17 Oct 2019 14:12:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 11:12:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,308,1566889200"; 
   d="scan'208";a="221469877"
Received: from eshoguli-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.19.56])
  by fmsmga004.fm.intel.com with ESMTP; 17 Oct 2019 11:12:01 -0700
Date:   Thu, 17 Oct 2019 21:12:01 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v23 v3 00/12] x86/sgx: Bug fixes for v23
Message-ID: <20191017181201.GI6667@linux.intel.com>
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

My earlier comments about doing first a single page EADD were based on
API where you provide mrmask.

/Jarkko
