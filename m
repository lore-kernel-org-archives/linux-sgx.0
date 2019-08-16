Return-Path: <SRS0=vX2d=WM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0477C3A59D
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 23:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 767232086C
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 23:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfHPXlf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Aug 2019 19:41:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:41682 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbfHPXle (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Aug 2019 19:41:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Aug 2019 16:41:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,395,1559545200"; 
   d="scan'208";a="179817912"
Received: from spdempse-mobl.ger.corp.intel.com (HELO localhost) ([10.252.53.151])
  by orsmga003.jf.intel.com with ESMTP; 16 Aug 2019 16:41:31 -0700
Date:   Sat, 17 Aug 2019 02:41:30 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v22 v2 1/8] selftests/x86/sgx: Align enclave binary
 on 4k boundary
Message-ID: <20190816234130.jsar33znkuyi4he6@linux.intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
 <20190813011252.4121-2-sean.j.christopherson@intel.com>
 <20190816135421.6kbbt4zeiaijm3uk@linux.intel.com>
 <a340b65e-917f-3230-49ea-c630c5af509b@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a340b65e-917f-3230-49ea-c630c5af509b@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 16, 2019 at 03:36:11PM +0000, Jethro Beekman wrote:
> On 2019-08-16 06:55, Jarkko Sakkinen wrote:
> > Requirement is too way strong vocabulary here. Whether it should be required
> > or there should fast and slow paths is debatable.
> 
> After userspace has gone through all the trouble to map an enclave using the
> new API, aligning the input to this ioctl seems like a minor inconvenience.

You might in some cases mmap() less than the ELRANGE for legit reasons.
It is not really a question of convenience but rather just taking
advantage of robustness brought by the loose binding to the VMA.

/Jarkko
