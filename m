Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0994CC2BA19
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 11:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE610206F5
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 11:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilCnozJA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgDFLBn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 07:01:43 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34808 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgDFLBn (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 6 Apr 2020 07:01:43 -0400
Received: by mail-lf1-f68.google.com with SMTP id x23so1281710lfq.1
        for <linux-sgx@vger.kernel.org>; Mon, 06 Apr 2020 04:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fvGHZ6G0ACfh/x9r1t6TjTeAJ6kMPZ6mUPhFK0p1WN0=;
        b=ilCnozJAzawg3L/JlAPbwD9O08/spbI1xC6am4OqtgPMOYE1WEOl0GKGSXe545zHGg
         WMlKgnTBHQ42AIODSWQV04ae8qhtAS8LJ9MYT9rVKymGoiXDgBYyKzGCn8JJvGxl1I6o
         iZse3xsJAyvTKXuiZLmKlsBAKM2LcrMiIVLZYSZJLhC3Mh9ErW9P4iV97ZDFVAal0+ak
         6bPN2aVf4erI/mGjiWznVCmEt5UknSjlq8SKIRUJn60SQORW421ScKv4DIBHYi6Mopck
         J/3+F1J175+uOJBBA6Kqd0x171B8SAugTAobXP8d3Si2YpFBuT+L7wiyDne7yYBwGzEr
         AXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fvGHZ6G0ACfh/x9r1t6TjTeAJ6kMPZ6mUPhFK0p1WN0=;
        b=k7DuyyuOtUK4n0xJqenbEvP4qRuCe5JReCHgGZGA2VxU0WQAD5cfaX1ZS3eZHzKcDa
         lvBKiaVlkacpn/nf7kOT+nyxpRYGn5s1VgAWJuNu1jv9jOUS/lk/ybZqd+EmPGcu3nfQ
         9iCAtAA8Y+4Po2FmGOZ6S4BiLl5Jz9BT99GJst5z3CKnto6SBZyAet6XgXY7sG/Zabzk
         9WEuW7WFvFUUwF7oWn56btC2333usgIrm5bSb8RRIoVSkwaCmO4wnH9PS6CyNKZIM9Gi
         hGS75Enb5s+MImb9wX4DRyyqdOEcgIErgFiIst200atLmFlkpy3XPnF7x3XFph9DLh2Y
         JXQg==
X-Gm-Message-State: AGi0PuZ/1/PPLbz2eFBFH0bGHUC3yFxkAxAf9IqMhSW3jEOAYKUm3CLK
        Ncg8xznjbm+XqgLh2soOzIydKZjZiRM=
X-Google-Smtp-Source: APiQypJ2MxEiMZl/x+ocpAOY2Pc6B/NpSDiAujpqE18Rpb6xrWiZSb6r55xWMrJeSBBIcerjpvaZHA==
X-Received: by 2002:a05:6512:1113:: with SMTP id l19mr5934834lfg.77.1586170901098;
        Mon, 06 Apr 2020 04:01:41 -0700 (PDT)
Received: from [192.168.1.38] (88-114-211-119.elisa-laajakaista.fi. [88.114.211.119])
        by smtp.gmail.com with ESMTPSA id g9sm2151845lfc.24.2020.04.06.04.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 04:01:40 -0700 (PDT)
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
References: <20200403220848.GA7588@linux.intel.com>
 <F117745A-E01B-499E-B9E4-201C1C08258D@amacapital.net>
 <454e7252-8827-510d-65f0-f2ca60208e27@fortanix.com>
 <ea7471ff-146a-73af-903d-34552614b302@gmail.com>
 <e55d56bd-7960-d89a-712e-49daadccb88e@fortanix.com>
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <dd2529f7-6079-e1ef-130d-648cc6e0b9b6@gmail.com>
Date:   Mon, 6 Apr 2020 14:01:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <e55d56bd-7960-d89a-712e-49daadccb88e@fortanix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6.4.2020 9.42, Jethro Beekman wrote:
> On 2020-04-04 09:27, Topi Miettinen wrote> Then initramfs should make a similar exception as with v86d and grant exec to /dev.
> 
> I'm not sure this is a reasonable approach. Expect most devices with an Intel processor will have the SGX device going forward. Then, no one is using noexec, so why have this logic at all?

Intel does not control the whole market yet, does AMD also offer SGX or 
similar? Will SGX be also available for consumer devices? Are distros 
going to enable SGX, will it benefit their users somehow?

Perhaps the sgxfs approach or something else (system call?) would be 
better after all in order to not force exec just because of one device. 
/dev is usually writable, so allowing exec means breaking the W^X 
principle for filesystems.

-Topi
