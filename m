Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF52EB64DC
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jul 2023 22:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjGRWHS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Jul 2023 18:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbjGRWHH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 18 Jul 2023 18:07:07 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1A61FF7;
        Tue, 18 Jul 2023 15:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689718004; x=1721254004;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jCMjbnqIpbK5qtNyuKgUPxCbtUR678kZQh+zhMGb05o=;
  b=aBJOcn2trMxVN6cXitFYj5QCgA1HWbHOPDX9i+lj/qs/r7vsVEwYmva0
   nSqNYi6DSA1tt5GXVt9T72a5VcGXGDG070PSwoEOeTKSaHj3syKYx5OLi
   cM5f1WvEq8y+fekK3WvpnfJuRvRGc8d4fXtI4OdBqd/xbIv3e1xr/EBCV
   w80nIlxC2QdYpprnIDVHb7pwzZ3FMqdN/7iACftbN8c+M1gRLAt5S78lr
   Xj2HhvJs03UmV06W2Hb/ZKC4kotQoeo5utwCjubmeQ1CFJwvv0zkdexhy
   VmolHJjqcCUJO6MIcQN0iei/ZcYF85YkY4X//33e9VEHoX8s9dTMA7uan
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="368967359"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="368967359"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 15:06:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="789217133"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="789217133"
Received: from unknown (HELO [10.209.37.195]) ([10.209.37.195])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 15:06:00 -0700
Message-ID: <891d530f-fa84-aed7-7465-b4722e983e92@intel.com>
Date:   Tue, 18 Jul 2023 15:05:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] x86/sgx: fix a NULL pointer
Content-Language: en-US
To:     Haitao Huang <haitao.huang@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc:     kai.huang@intel.com, reinette.chatre@intel.com,
        kristen@linux.intel.com, seanjc@google.com, stable@vger.kernel.org
References: <CU4OBQ8MQ2LK.2GRBPLQGVTZ3@seitikki>
 <20230717202938.94989-1-haitao.huang@linux.intel.com>
 <dfb1f233-aebd-50cf-8704-e83b91ee110a@intel.com>
 <op.18ah5mn3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <b5779418-e2a4-ca7a-866f-97e49cd272cb@intel.com>
 <op.18aontlmwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <eb1aea6f-3688-f871-2335-ff911a51ef52@intel.com>
 <op.18aqz7sbwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <ad2d9610-61c0-4719-9df1-0116ef317d8a@intel.com>
 <op.18asliuzwjvjmi@hhuan26-mobl.amr.corp.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <op.18asliuzwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/18/23 14:57, Haitao Huang wrote:
> Okay, that explains. I would consider it still triggered by high
> pressure blips 😄
I'm talking about a "blip" being a single allocation.  It's *LITERALLY*
the smallest (aka. lowest) possible quantum of memory pressure.

So go ahead and try to write the changelog without "high" or "low".
But, sheesh, if you and are somehow using "high" and "low" to describe
the exact same condition, I think that's a rather large communication or
understanding problem somewhere.  It doesn't bode well for this simple
patch.
