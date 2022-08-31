Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0C0ECAAD3
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Aug 2022 17:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiHaRoC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Aug 2022 13:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbiHaRnm (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 31 Aug 2022 13:43:42 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D982DEB44
        for <linux-sgx@vger.kernel.org>; Wed, 31 Aug 2022 10:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661967787; x=1693503787;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ojx0rhFh2bK04ktBnZhbYB4RuYkmWpO2q7XzhuYQxVY=;
  b=LZlfCwpar2UyF/4+6DGw524HUexO2APQEEDd9pt17g+cTnZUkLr5s5II
   R2Lk+H+ZIIff4C0iq4hw4x//YkVAAqJK0aTTVFktQMhm2NF+Z6FVg4e+T
   Pf5OibhQVx+m7MfiuFt8W7Dt2CHPlCvBiFnZDJNExqXm8KEG1SCiIlGM0
   hb3C8HYuMVFa/qR9X0sr3asJubx0mz4jct8r1bYnlMfUFLj2tuASE7ph1
   KyfHA6GEU2pQ38m5XQ7RY0DFH1R0XtSK+8ICZ6BRJbYMYRBUHPwu2NsgZ
   kQWi3fSutMDMqOUNYlaZwnWiMiAcwHSatmNVNxihEK0Z6PnqqCCc/vWGe
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="296787390"
X-IronPort-AV: E=Sophos;i="5.93,278,1654585200"; 
   d="scan'208";a="296787390"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 10:43:06 -0700
X-IronPort-AV: E=Sophos;i="5.93,278,1654585200"; 
   d="scan'208";a="738183298"
Received: from aametzl-mobl.amr.corp.intel.com (HELO [10.251.3.56]) ([10.251.3.56])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 10:43:05 -0700
Message-ID: <cfa17cdd-796e-be75-d371-9dea9c2876e8@intel.com>
Date:   Wed, 31 Aug 2022 10:43:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 0/6] x86/sgx: A collection of tests and fixes
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
References: <20220831173829.126661-1-jarkko@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220831173829.126661-1-jarkko@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Jarkko,

What is your expectations of this series?  There's nothing in the cover
letter.

Do you think all of this is urgent material that needs to go to Linus
for 6.0?  Or is it all 6.1 material?
