Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175C5C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Jul 2022 19:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbiGVTOr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Jul 2022 15:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiGVTOr (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 22 Jul 2022 15:14:47 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51925A6F9F;
        Fri, 22 Jul 2022 12:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658517285; x=1690053285;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=byfGDtmkRkASevcEx81TQf4ng/7TX7hruHD1iCw+1aE=;
  b=gJRyAx3X+J69kA4NaBh26aap/sU8iO4YWokQT7tC2TYjYwiv5JiSvEdq
   CP6WKkPihaEhmYYeCVHaMcIYx8WDqOX4oKs+y3JnbeQiygsCLhlNwVnpg
   bwqVM+Fe6uZyeMYWDsR6GzLlfvw/uondmTuT1RtWreQPthQQr6JJFdamj
   V3WwzQC4EyMWMGmzrXGEjPeos8qlgo33hJTRVQNrrZdb3fVXtG/wd2onM
   UMwV7BVgNiUn8FbcNuJibrZCWWMHRSgVLFjSOvk63fN4v2IXp4wQiig7z
   Ys0cLshCx/E+q6qZnXPruGeca3+WjvUI7/148GrD5mUrLOriIHDcYLkC0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="349089077"
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="349089077"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 12:14:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="926158163"
Received: from jnoah-mobl.amr.corp.intel.com (HELO [10.209.71.211]) ([10.209.71.211])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 12:14:43 -0700
Message-ID: <effbeeb0-6980-84e1-bb7e-75a279d6d834@intel.com>
Date:   Fri, 22 Jul 2022 12:14:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] [v2] x86/sgx: Allow enclaves to use Asynchrounous Exit
 Notification
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, dave@sr71.net,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Kai Huang <kai.huang@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220720191347.1343986-1-dave.hansen@linux.intel.com>
 <YthcXSTfjoM+jjvN@google.com>
 <00b07459-5512-b00b-636b-f35845ec369f@intel.com>
 <YtrzwbLZjc+jURDI@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <YtrzwbLZjc+jURDI@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/22/22 12:00, Sean Christopherson wrote:
> 		/*
> 		 * Assert that KVM explicitly allows or denies exposing all
> 		 * features, i.e. detect attempts to add kernel support without
> 		 * also updating KVM.
> 		 */
> 		BUILD_BUG_ON((KVM_SGX_ATTR_ALLOWED_MASK | KVM_SGX_ATTR_DENIED_MASK) !=
> 			     (SGX_ATTR_PRIV_MASK | SGX_ATTR_UNPRIV_MASK));

Looks good to me.  I'll do that for the next version.  Thanks!
