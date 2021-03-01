Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45A2C433E0
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Mar 2021 11:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8857964DF5
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Mar 2021 11:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhCAL3R (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Mar 2021 06:29:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:5277 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232148AbhCAL3Q (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Mar 2021 06:29:16 -0500
IronPort-SDR: nLdTNyyjlLeFFntVhmPPyxkqiaeRMZU8fD4XfUZD67Ty6R3ZHk7x1lzS/H5gckSMkXvn1nPss+
 x+hfhCrUj/zA==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="186486727"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="186486727"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 03:28:33 -0800
IronPort-SDR: 7bKXkkVftKxVl0UWJwtsCFVo5vLEcxrTfnuIbF/6XpbduY0LmzqBYr0IowWQINfktXr2cRwbuP
 Xn8drNe3cl1A==
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="434221787"
Received: from sanand-mobl.amr.corp.intel.com ([10.251.13.183])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 03:28:30 -0800
Message-ID: <e509c6c1e3644861edafb18e4045b813f9f344b3.camel@intel.com>
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Date:   Tue, 02 Mar 2021 00:28:27 +1300
In-Reply-To: <20210301105346.GC6699@zn.tnic>
References: <cover.1614590788.git.kai.huang@intel.com>
         <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
         <20210301100037.GA6699@zn.tnic>
         <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
         <20210301103043.GB6699@zn.tnic>
         <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com>
         <20210301105346.GC6699@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2021-03-01 at 11:53 +0100, Borislav Petkov wrote:
> On Mon, Mar 01, 2021 at 11:40:02PM +1300, Kai Huang wrote:
> > SGX2 means "Enclave Dynamic Memory Management", which supports dynamically
> > adding/removing EPC pages, plus changing page permission, after enclave is
> > initialized. So it allows enclave author to write enclave in more flexible way, and
> > also utilize EPC resource more efficiently.
> 
> So how is the enclave author going to use "sgx2" in /proc/cpuinfo? Query
> it to know whether it can start adding/removing EPC pages or is this
> going to be used by scripts?

I think some script can utilize /proc/cpuinfo. For instance, admin can have
automation tool/script to deploy enclave (with sgx2) apps, and that script can check
whether platform supports sgx2 or not, before it can deploy those enclave apps. Or
enclave author may just want to check /proc/cpuinfo to know whether the machine can
be used for testing sgx2 enclave or not.

However this is just my 2 cents.

> 
> > Yes I can add "why" into commit message, but isn't the comment after X86_FEATURE_SGX2
> > enough? I think people who are interested in SGX will know what SGX2 is and why SGX2
> > is useful.
> 
> The point is, the commit message should say how this flag in
> /proc/cpuinfo is going to be used - not what people interested in sgx
> might and might not know.
> 
> /proc/cpuinfo is user-visible ABI - you can't add stuff to it just because.
> 

Thanks for the explaining. Will do.

