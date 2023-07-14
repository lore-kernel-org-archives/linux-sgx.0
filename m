Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6493DC001DC
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jul 2023 20:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbjGNU0o (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Jul 2023 16:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbjGNU0n (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 14 Jul 2023 16:26:43 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6AF35A0;
        Fri, 14 Jul 2023 13:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689366402; x=1720902402;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=hN1j+GFrFTi2sMdb0x6EvEauXOQiHe+xtthEmkTSYxI=;
  b=bisEsH+RDsJv3bzPwySZf3SxqsJzyymVWfNewe80yQEgKrvhaMOUQSZw
   +pQNIHO2r1xq4iJaB7fZ2m3tvYXCCWJqLP36rNudlfGwKXth4LfECZsxG
   O2hutCfIaMR4nQob3CAE0PgR67Q4AHshG6KCdIsT88iZ7otFwCLOfVnQW
   UREH6/xjlc9/eQdrB+szPx8c5YJcRXQotuawhYude4YWIqNFcZe0qPnfS
   DK1Bo9zVmiMSfTkYn/bSgjKUIdajkP9VzGj9JKO8DVj3gmu7DFiUnPlFa
   4RspIqvr3hGYB9/xgxWYjABYq+cEiYuT5r1237rMQDSe+91NgSGyE+N3Q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10771"; a="363032479"
X-IronPort-AV: E=Sophos;i="6.01,206,1684825200"; 
   d="scan'208";a="363032479"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 13:26:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10771"; a="969152359"
X-IronPort-AV: E=Sophos;i="6.01,206,1684825200"; 
   d="scan'208";a="969152359"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.92.18.126])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 14 Jul 2023 13:26:39 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     jarkko@kernel.org, dave.hansen@linux.intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        cgroups@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Haitao Huang" <haitao.huang@linux.intel.com>
Cc:     kai.huang@intel.com, reinette.chatre@intel.com,
        "Kristen Carlson Accardi" <kristen@linux.intel.com>,
        zhiquan1.li@intel.com, seanjc@google.com, bagasdotme@gmail.com,
        linux-doc@vger.kernel.org, zhanb@microsoft.com,
        anakrish@microsoft.com, mikko.ylinen@linux.intel.com
Subject: Re: [PATCH v3 22/28] Docs/x86/sgx: Add description for cgroup support
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-23-haitao.huang@linux.intel.com>
Date:   Fri, 14 Jul 2023 15:26:38 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.1729qobwwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <20230712230202.47929-23-haitao.huang@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> +
> +  misc.events
> +	A read-write flat-keyed file which exists on non-root cgroups.

It's actually read-only for this file. Will fix.

Haitao
