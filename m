Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2566EC2B9F4
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Jun 2021 23:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2E39613F2
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Jun 2021 23:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFYXIv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Jun 2021 19:08:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:35147 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhFYXIv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Jun 2021 19:08:51 -0400
IronPort-SDR: b59YcC4ebousSZQS/Qd1jwcNwrAy6LKwnHc9Ocofgdm5NbgFRO4sj/vcTbsdmvdTCi+AXSGBsR
 Qb9VAhOLPj3A==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="268884449"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="268884449"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 16:06:29 -0700
IronPort-SDR: NasZmMKfyZRgQ/AzAbvWlT5BK95VDtBndp4qsjWAJg98PDXH3SAoWJ5KlcPWZAnWxQ7fEhDPqL
 iEkuzgkXtFtw==
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="407110962"
Received: from slahiri1-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.179.195])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 16:06:26 -0700
Message-ID: <2be5bb5342ae568c198d61f5e8a8b4515b61ba66.camel@intel.com>
Subject: Re: [PATCH v2] x86/sgx: Add missing xa_destroy() when virtual EPC
 is destroyed
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, seanjc@google.com,
        dave.hansen@intel.com, tglx@linutronix.de, mingo@redhat.com,
        Yang Zhong <yang.zhong@intel.com>
Date:   Sat, 26 Jun 2021 11:06:23 +1200
In-Reply-To: <YNXej3ru9kxQugvR@zn.tnic>
References: <20210616003634.320206-1-kai.huang@intel.com>
         <20210623132844.heleuoxogrpz3cpm@kernel.org>
         <925090f035b8e749ea7aca8c857690c8afba7349.camel@intel.com>
         <YNWR+oSGfulOWziI@zn.tnic>
         <6df0600b755ca067a6c4ff82af47297feafa088a.camel@intel.com>
         <YNXej3ru9kxQugvR@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2021-06-25 at 15:47 +0200, Borislav Petkov wrote:
> On Sat, Jun 26, 2021 at 12:04:53AM +1200, Kai Huang wrote:
> > Oh sorry I thought the patch would go via x86/sgx branch
> 
> We usually send fixes through tip's urgent branches because they go
> straight to Linus and not wait for the merge window.
> 
> > and I didn't monitor the tip-bot2 mail which was moved to my local x86
> > folder.
> 
> That's not optimal because those tip-bot notifications are *exactly* for
> that - to let the involved parties know that the patch has been queued.
> 

Got it. Thanks for remaindering.

