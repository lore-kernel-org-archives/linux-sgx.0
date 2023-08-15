Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D37FC0015E
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Aug 2023 13:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbjHON5u (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Aug 2023 09:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237304AbjHON5e (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Aug 2023 09:57:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343AE198A
        for <linux-sgx@vger.kernel.org>; Tue, 15 Aug 2023 06:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692107853; x=1723643853;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=A8QsM5m8sgKxMJn59bTTku6xUrIy+khqt2hJueCaKS0=;
  b=ZWKVewzMh2AS+4ua+qNwU4YeazftbX0nPY/6a5HfnLq7DFI2vqfyAzyK
   VV60uG97hR4R14vhddN/0xlY9kcfCuA58fPnUyLQum+/43+8qnRhtBzzd
   R1ZBMOhIEVKT2hXCxaIj1arFxRzncfBz6VbaXWtYeh1GkD92NtV07UmGA
   ECxZhwqTWjYzVmDELdn22H2R/cy6+ieWa5rEkkfjXbaK2sZFtacP3bc4s
   wGOBuGq9B73PYp+f6spDCiLpVZSUlN2b4IKi0Rn/0zaV7BYea9wTfidME
   eFk7gLBJzDCfHYq1OFTWTfnx/jpv2TSiOE7U3EX1g1dEG4l4trgp7oogm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="351866330"
X-IronPort-AV: E=Sophos;i="6.01,174,1684825200"; 
   d="scan'208";a="351866330"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 06:57:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="736906815"
X-IronPort-AV: E=Sophos;i="6.01,174,1684825200"; 
   d="scan'208";a="736906815"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.92.64.13])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 15 Aug 2023 06:57:31 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     jarkko@kernel.org, "Jack Wang" <jinpu.wang@ionos.com>
Cc:     linux-sgx@vger.kernel.org, "Yu Zhang" <yu.zhang@ionos.com>
Subject: Re: [PATCH] x86/sgx: Avoid softlockup from sgx_vepc_release
References: <20230814043714.107971-1-jinpu.wang@ionos.com>
Date:   Tue, 15 Aug 2023 08:57:27 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.19p011pawjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <20230814043714.107971-1-jinpu.wang@ionos.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, 13 Aug 2023 23:37:14 -0500, Jack Wang <jinpu.wang@ionos.com> wrote:

> We hit softlocup with following call trace:
>  kernel: [ 2041.288210] Call Trace:
> kernel: [ 2041.288213]  <IRQ>
> kernel: [ 2041.288216]  ? watchdog_timer_fn+0x1b4/0x210
> kernel: [ 2041.288222]  ? lockup_detector_update_enable+0x50/0x50
> kernel: [ 2041.288225]  ? __hrtimer_run_queues+0x127/0x280
> kernel: [ 2041.288230]  ? hrtimer_interrupt+0xfc/0x210
> kernel: [ 2041.288233]  ? __sysvec_apic_timer_interrupt+0x59/0xd0
> kernel: [ 2041.288237]  ? sysvec_apic_timer_interrupt+0x6d/0x90
> kernel: [ 2041.288242]  </IRQ>
> kernel: [ 2041.288242]  <TASK>
> kernel: [ 2041.288244]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> kernel: [ 2041.288250]  xa_erase+0x21/0xb0
> kernel: [ 2041.288256]  ? sgx_free_epc_page+0x20/0x50
> kernel: [ 2041.288260]  sgx_vepc_release+0x75/0x220
> kernel: [ 2041.288263]  __fput+0x89/0x250
> kernel: [ 2041.288269]  task_work_run+0x59/0x90
> kernel: [ 2041.288275]  do_exit+0x337/0x9a0
>

If you would spin another version, please remove columns of the time stamp  
and "kernel"
Otherwise,

Acked-by: Haitao Huang <haitao.huang@linux.intel.com>

Thanks
Haitao
