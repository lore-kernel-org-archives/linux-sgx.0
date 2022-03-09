Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BC3C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 20:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238264AbiCIU6T (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 15:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236866AbiCIU6Q (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 15:58:16 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB586351E
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 12:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646859437; x=1678395437;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L0dWr0ikY863geSvsgceFooMbqPe8aYQqK+0vlH4juc=;
  b=ZL8SHbobBRE6/DqIKv8q2q64lEDYb3NH6VuQFjEY8CkkNft0iURc9GMk
   csP1juo4y1fvS3ajmeIJv67zB3uaNOgt9K4jNwkgcYrGw8bOxnQM3RGJH
   KZlU353lZR6KRJsgiqXM7b1e8L5P2YvEK8R+wWbWMcwAw3pceb1HIJ81S
   pCrDoceEiROH01EgYoWREQnHwkc3BbpqOMFBeeTkJaY+WY8IlmPvvcWrf
   8+LLNO10mr4HpMun6EMkR+uJD7D1MsWD6BG4uKztBgtMUIQUz2lNNLuhM
   yYtnqgoDFserpPwXRpB/L/rAisS8SZ8GlRiPQltSXHrgB7xwUBG01PtxB
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="235041625"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="235041625"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 12:57:17 -0800
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="632749815"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.125])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 12:57:17 -0800
Date:   Wed, 9 Mar 2022 12:48:52 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org, Ashok Raj <ashok.raj@intel.com>
Subject: Re: [RFC PATCH 00/11] Support microcode updates affecting SGX
Message-ID: <20220309204852.GA64195@otc-nc-03>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
 <78b2e9f9-3be0-8670-a827-0a8fe7bf9ba6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78b2e9f9-3be0-8670-a827-0a8fe7bf9ba6@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 09, 2022 at 12:32:40PM -0800, Dave Hansen wrote:
> On 3/9/22 02:40, Cathy Zhang wrote:
> > This series implements the infrastructure needed to track and tear
> > down bare-metal enclaves and then run EUPDATESVN. This is expected
> > to be triggered by administrators via sysfs at some convenient time
> > after a microcode update, probably by the microcode update tooling
> > itself.
> 
> Cathy, if it isn't abundantly clear by now, everyone seems to hate this
> part of the implementation.

Certainly if there is good information that this ucode brings in SGX fixes
it absolutely makes sense to do that. Right now this information is only
communicated via release notes and some other agent like the orchestrator
decides the kill SGX part.

If we had a programmatic way to determine EUPDATESVN is required this
automatic kill is the way to go.
> 
> Let's just make this just do EUPDATESVN as a part of the microcode
> update process.  No new ABI.  No trying to preserve enclaves.  Kill them
> early, kill them all, and be done with it.

Maybe use some meta-data that can communicate this directly.

> 
> If we merge that and we have end users chasing us with torches and
> pitchforks because their precious enclaves were torn down, we'll think
> about doing something different.
