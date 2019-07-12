Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA8BC742A8
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 04:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 305E320644
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 04:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfGLERc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Jul 2019 00:17:32 -0400
Received: from mga17.intel.com ([192.55.52.151]:27116 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbfGLERc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 12 Jul 2019 00:17:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 21:17:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,481,1557212400"; 
   d="scan'208";a="174347880"
Received: from gonegri-mobl.ger.corp.intel.com (HELO localhost) ([10.252.48.192])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jul 2019 21:17:31 -0700
Date:   Fri, 12 Jul 2019 07:17:30 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v21 0/2] x86/sgx: Use SRCU and mmu_notifier
Message-ID: <20190712041730.2u2pc5dqeie5kfv2@linux.intel.com>
References: <20190711161625.15786-1-sean.j.christopherson@intel.com>
 <20190711215138.ehcdjtkqitbrop5o@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711215138.ehcdjtkqitbrop5o@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jul 12, 2019 at 12:51:38AM +0300, Jarkko Sakkinen wrote:
> On Thu, Jul 11, 2019 at 09:16:23AM -0700, Sean Christopherson wrote:
> > Add SRCU support in a standalone patch.  I included the mmu_notifier patch
> > as well so that you can compare approaches without having to wait on me
> > for additional input.
> 
> Can you rebase these to the latest master. I'll apply them once
> I wake up (about 1AM now). Could just work around with raw patch
> would need to get sleep first anyway. Thanks.

No need, woke up early. I can do these manually with patch -p1.

Thnaks.

/Jarkko
