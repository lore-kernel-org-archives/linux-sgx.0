Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F50C433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 16 May 2022 02:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbiEPC3S (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 15 May 2022 22:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbiEPC3R (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 15 May 2022 22:29:17 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EE1F5BF
        for <linux-sgx@vger.kernel.org>; Sun, 15 May 2022 19:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652668156; x=1684204156;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TlZIhxZLLgMOFOHVVCkcJIY4Gx568dpZO99gVJNJoB8=;
  b=CO9Jex2D06lS3yUdluFaVUMAK4U1yv5X1zrrH8SKOYCDVGcDApOqN12P
   PCpkITQu9ONfj6DSiAuNk4PYrI2NdDy3HLnqevGkKv8qy1pyv3Six0sFR
   ROyCpLYHRtNP/LSjG2ZkwIL2BUDmEq27aK0B0+/XYrnOAB4TwJgkOiLaB
   AfsoAI9HLMhTPCp5Xd5oucydLQXVTd4AQWy0VS4p+FuTH1cCk1tOC93gv
   F1eNjPlvGZHImNT1qN2F29mxw+4a911M7tdho4sPwfPVfzKp8QtEFKxhs
   NH4GthDE3qEU1I2kBSB7wZwY+cawOSgc/ZfHcnxSqUh6jQ7INpcCoBq4V
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10348"; a="258281722"
X-IronPort-AV: E=Sophos;i="5.91,229,1647327600"; 
   d="scan'208";a="258281722"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2022 19:29:14 -0700
X-IronPort-AV: E=Sophos;i="5.91,229,1647327600"; 
   d="scan'208";a="638050172"
Received: from mmzhu-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.1.156])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2022 19:29:12 -0700
Message-ID: <968e75d65a37ff7ae21f84875b78fb1ebbbef33d.camel@intel.com>
Subject: Re: [PATCH 0/4] x86/sgx: fine grained SGX MCA behavior
From:   Kai Huang <kai.huang@intel.com>
To:     Zhiquan Li <zhiquan1.li@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Du, Fan" <fan.du@intel.com>
Date:   Mon, 16 May 2022 14:29:10 +1200
In-Reply-To: <35284def-ca7f-d42b-164f-1c49eb8977ee@intel.com>
References: <20220510031646.3181306-1-zhiquan1.li@intel.com>
         <YnuQJaM0p7gD5qel@kernel.org>
         <d8e3f194-bd52-4405-8cdd-db8710e71509@intel.com> <Yn5tPS0aLXBgHtYT@iki.fi>
         <55ffd9475f5d46f68dd06c4323bec871@intel.com>
         <35284def-ca7f-d42b-164f-1c49eb8977ee@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, 2022-05-14 at 13:39 +0800, Zhiquan Li wrote:
> On 2022/5/14 00:35, Luck, Tony wrote:
> > > > Do you think the processes sharing the same enclave need to be killed,
> > > > even they had not touched the EPC page with hardware error?
> > > > Any ideas are welcome.
> > > 
> > > I do not think the patch set is going to wrong direction. This discussion
> > > was just missing from the cover letter.
> 
> OK, I will add this point into v2 of cover letter and patch 03.
> 
> 

I don't think you should add to patch 03.  The same enclave can be shared by
multiple processes is only true for host enclaves, but not virtual EPC isntance.
Virtual EPC instance is just a raw EPC resource which is accessible to guest,
but how enclaves are created on this EPC resource is completely upto guest. 
Therefore, one virtual EPC cannot be shared by two guests.


-- 
Thanks,
-Kai


