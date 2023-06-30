Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4411AEB64D9
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Jun 2023 00:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjF3AOn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Jun 2023 20:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjF3AOl (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 29 Jun 2023 20:14:41 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1A02D52
        for <linux-sgx@vger.kernel.org>; Thu, 29 Jun 2023 17:14:41 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b8130aceefso10702595ad.2
        for <linux-sgx@vger.kernel.org>; Thu, 29 Jun 2023 17:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688084080; x=1690676080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nLprscKQrPSaNZpBrl5P4xNh3bjOi0N03k3Olq2ONxw=;
        b=AJlM3hvdfFaXfqh9lPzBqOft8Yrj11jgVSYi4Mm3dVooprWGyOnI+VVWdVIrgsK5Pz
         TfiCStpViMkYah1VtTMCEc/yOyjFp9/kioI4jfqr2spnaN4rBfoZeAhEmM1xMxs3DoMl
         ZuKcjW0oeZOAzeAuxt60CkA8H7N3U/me15MJXpzjSmACbhLuxKflqIMAlFTNfXhXunp/
         YkuI4YrXNU8+wT4EY8da6c+R5cJ3STOk/JnYgEtdopSwCKvs0kFTfvy+QAwJeKKt/sUe
         VvuFnvNVXyTselMBzLotaDDAD9tv38t6kL69ty8kLgPoGOLW/SRJn15/796qLBNai83I
         hV+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688084080; x=1690676080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nLprscKQrPSaNZpBrl5P4xNh3bjOi0N03k3Olq2ONxw=;
        b=NauZ46poLyccCScdY8DOOmltrCvhsDEN9Q4Kwa7yK0DcbX02ESAhf49AVEFLzHS2gL
         6BtEmdu9H69UGHMdQNtGE8F6wAnhLeiwRr3ixJKF1JmI9wUaMa1OX1i2RTUgmT47ep2S
         mRQQ3MJc4CQPSH5Aqv0X7dbjEBqjqoa8cTnWv3bp9pdmiCTokOEqFbjPep3DjUn/Bn3k
         TVByz/5akiBCYpv8BbObFC5WbT5nRa9UlxzXSmun9ynqhBXM3Udkmx4zgB9y3PVuoS8T
         6lc/EkN62CtI4wreLg08IgUO/NXOGzz7JaXH3CRN3ULKKJZiz94nPWleRfiJNL0rOczh
         uq0A==
X-Gm-Message-State: ABy/qLat5FZtg699xw1KR7YQT195+c6FTSccFBx9pUKu0dia1RmakzIG
        CLgXYBhWJTTgPMVSZsq475ukDmARLEI=
X-Google-Smtp-Source: APBJJlGWD3hvfbp1VFE+VdjzgXCudoM0efltzc3Wi23puYB1AprVNIUEBHZnsXEHQUuxLvbhRSb2t+qE+zs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2683:b0:1b8:1e05:ed17 with SMTP id
 jf3-20020a170903268300b001b81e05ed17mr354657plb.10.1688084080616; Thu, 29 Jun
 2023 17:14:40 -0700 (PDT)
Date:   Thu, 29 Jun 2023 17:14:39 -0700
In-Reply-To: <50913a11353b17861c13ebb53305dd370c8b8b43.camel@intel.com>
Mime-Version: 1.0
References: <ZJTEpH2yYtHmTRWr@google.com> <66f22efc5a920a805d6863dcc152c3c12e8fb6fb.camel@intel.com>
 <ZJoRHU1CHxIuDH29@google.com> <7e78ec8fd22ad9f8b828fa00b9811bbfcf855b2c.camel@intel.com>
 <ZJr3PthzDgugKDcO@google.com> <1a980d3ce2caec1cf44bf97d52fa08fbe72e741f.camel@intel.com>
 <ZJxKV1/2M+OeIXAN@google.com> <60f96055b73932ef3550eb562d2f42440d534e69.camel@intel.com>
 <ZJ2T6zJSnLtKMPnE@google.com> <50913a11353b17861c13ebb53305dd370c8b8b43.camel@intel.com>
Message-ID: <ZJ4eb8wGbLa06+wX@google.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 29, 2023, Kai Huang wrote:
> But SGX usrespace needs a *exact* address.  MAP_FIXED is the only ABI can
> guarantee this.

Yes, but you're assuming that userspace is sane and robust.  It's *very* possible
that there exists userspace that doesn't specify MAP_FIXED, but works anyways
because their setup doesn't cause conflicts and so the hint is sufficient.
