Return-Path: <SRS0=RmO4=V2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC408C7618B
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jul 2019 14:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A67232067D
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Jul 2019 14:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfG2O4j (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Jul 2019 10:56:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:53868 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbfG2O4j (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 29 Jul 2019 10:56:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 07:56:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,323,1559545200"; 
   d="scan'208";a="370541520"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 29 Jul 2019 07:56:38 -0700
Date:   Mon, 29 Jul 2019 07:56:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: Bug in EPC paging
Message-ID: <20190729145638.GD21120@linux.intel.com>
References: <b1b95c9c-9191-64d4-37f3-7741cbb0c157@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1b95c9c-9191-64d4-37f3-7741cbb0c157@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Jul 27, 2019 at 11:16:01PM +0000, Jethro Beekman wrote:
> A user is reporting CPU soft lockup with Intel SDK version 2.1 and 2.5
> driver. This only happens when using SGX in conjunction with DPDK (Data
> Plane Development Kit) in the same process. The process is running two
> enclaves that together are bigger than the EPC.
> 
> Dmesg output:
> 
> 2.1 driver:
> https://github.com/YangZhou1997/dpdk-sgx-crash/blob/master/dmesg-full.log
> 
> 2.5 driver: https://github.com/YangZhou1997/dpdk-sgx-crash/blob/master/dmesg-full-2.5.0.log

The log from 2.5 doesn't show any SGX activity, rather it's generating
remote TLB flushes during CoW.  That would imply this is a generic remote
TLB flush (or SMP function call IPIs) issue and not an EPC bug.

> 
> Enclave memory layout:
> https://github.com/YangZhou1997/dpdk-sgx-crash/blob/master/sgxs.info
> 
> -- 
> Jethro Beekman | Fortanix
> 


