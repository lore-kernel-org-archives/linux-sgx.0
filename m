Return-Path: <SRS0=nYZY=5T=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66EAC43331
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 15:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F064206F8
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 15:50:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="AV0r7Yfl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgDCPuP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Apr 2020 11:50:15 -0400
Received: from sonic313-14.consmr.mail.ne1.yahoo.com ([66.163.185.37]:33993
        "EHLO sonic313-14.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728263AbgDCPuO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 3 Apr 2020 11:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1585929013; bh=opqtsuppbo75z4wQuJfd8i/cBTNbO0ejYDZb1ZmxeiY=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=AV0r7Yfl6PdvnHI10df0c9YL49tzSfobuAxGuv85AumSU+eDUMZ+buJ58McMbTov1rxsXneBGyZGEK48Dn/VfddNrFSFimPtcorDBhmCa+m+wRQ+kbeM94gwdEvX0/1U8YdfV/4W4iOAv5i7nKtMK6LPzgUNvGyS6ctiN6chSTKeFkAbC+TeZgL+lWizO8wEOdArcN8jukF2BBgOLcp0aVa4rA7h4LKSrXO3z76rImWIQj1ziMuLq7LS60pf+5F9Tz1DQXUayE7+Nqr8bnmVHAwvL0H1g0IL2Tvs1HRiN/HGXYsmSYlYav7h5yDecgyEnIPU8MIje014XjGs5O0IAA==
X-YMail-OSG: 67gu9U8VM1m6BGEJ4X_6I5aiVMzaondildM9kCdiy0d2O7OfQfVZUKxm3aMWSsz
 UBhjsEpv5Xoxi.DT7iYIzyPK0MVH3pGszL7dA3qt.ovlN3D0lKmxLn09Q3YD0q_n3ylIZQ0vWxeF
 6gq54avWM0Oy9FMtyLOtTqOon34U25ry6b9YELLnHptDcYp0m6tiIV5ys9r.9th9zSG5POjCBHw0
 lxKT4WcszHfR9uVi9U_tH9bXwzAun33Fo.IT6NG6wK9vUicJdjKFGUqIISvcDKGNFrvpPHRr.caF
 2IY7jCDjI9I4IIpt2mLYotT99mAJn8TEB3BnOmOUq_Z2vVqg4lE3qGobYsPXfL78mfV_.o.qneHx
 bSIJyyaOINHkbS0kIeOd8SBn.qTMgwKtCfeJFCuKqPElJSwWFc5AFqHr3LMTthHHJIr1KnXtiuCk
 g8McVWFVgufrUCvGy5rx_qbveforTX.6ykowv8bDqfCF6iNOW_57U3hCPenz6ua6uGU40z4gn7kk
 VGSf7WzYZGeXIo9Ly51epEqyxKWKLLjACqReMqJb7nyV1Bu0JmKxjQFA6zRFuF8nNxb2RqEjo4Tq
 h5Dk2RkltNYWKxcpUyGSYqDx9L_gyl8KdyKsDdlIbJCaoR1Sd_jhKaHcoj6Iw45G69O0G5xuYJEE
 QW2M.WZc0RrndyG3..WRtT8ajp584bDOMxE_jtgY4MT77csH.6G9nB0YvfNwjhr0_MPh7KYatM_b
 Aq.qcD5QeMGaHr9WssN7NFjaNZvR99_uKRasM8tuQG8SR3CL88HjiQkyBXKPKQZSSVwcVQGfabeH
 vTRCPByReiKqse3pvdiU2AS1LUJEobnh5tQedEp6kucx_Ei39WvrHhp9Jl22BFemnydQDJctu.Dj
 CRrkfetmfTv4uYAJB.pX.arWSBqS8o3SQ9d28_KD.UhmuCybbUjgQglMxL3XiakHx_lXB4Bt828i
 URvRRLi8xl7iMd6QaRr4nVNYGAVLROjBcuuK3NVTop53uIE126t99XuVenBAGTH128v2taxifZCN
 PQ3YKHH0CeOw2bkFA839g3zJObBt3o1XyZ7sjLoWPOg7F2w6D7RmmyKFu2xkgCFqpAlJxhcXeMLc
 yjHAj109I3BW3lfolmWHX9TRsnz53uXm0VeFbhj8E10DAQQWHtH4AvCvu0gxXlw0jawR8shLO6IE
 GJrd5k_g9bx89QeWWpebyDkVgLYXRM3.zbfdnGx2rFG_u7vzOQw2ijU09iLHUYj2pciqMmo8XCMP
 XQVcS5v5IyIsgnaMLzYWcfRSLp0y99puYVWKIS2kWbF7BHGSpc0E8gGuMu5Ropmeu_OcwArxHhgF
 pR_H3J6Nb7araTnx695XhLN3pua1_LP4y4k0sK41RIb1YYyE3KB.6NTh7oguAv9ZWHOfHrRi8abJ
 FmL6Yl_YSKL.L7Rx7hi2UCq5rPqqTKFpnSxdqvMrDzNZvSX6kCiu2
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Fri, 3 Apr 2020 15:50:13 +0000
Received: by smtp427.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID f4edd790cf14dbd2cb6ab3561fd4f383;
          Fri, 03 Apr 2020 15:50:10 +0000 (UTC)
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
 <20200331114432.7593-3-jarkko.sakkinen@linux.intel.com>
 <CALCETrXz4YK9ubCAyBLm4BjqYEK-wt1491QPLDyumJe9t0LJ2A@mail.gmail.com>
 <20200401002443.GE4847@linux.intel.com>
 <CALCETrW8pLFRAnQdpxuBG-CDuUN5B8T-FqN5TvAVD--ZR=78-Q@mail.gmail.com>
 <20200403065621.GB25305@linux.intel.com>
 <f8698536-074e-6562-05df-26145a4c43b9@schaufler-ca.com>
 <20200403153041.GA2787@linux.intel.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 mQINBFzV9HABEAC/mmv3jeJyF7lR7QhILYg1+PeBLIMZv7KCzBSc/4ZZipoWdmr77Lel/RxQ
 1PrNx0UaM5r6Hj9lJmJ9eg4s/TUBSP67mTx+tsZ1RhG78/WFf9aBe8MSXxY5cu7IUwo0J/CG
 vdSqACKyYPV5eoTJmnMxalu8/oVUHyPnKF3eMGgE0mKOFBUMsb2pLS/enE4QyxhcZ26jeeS6
 3BaqDl1aTXGowM5BHyn7s9LEU38x/y2ffdqBjd3au2YOlvZ+XUkzoclSVfSR29bomZVVyhMB
 h1jTmX4Ac9QjpwsxihT8KNGvOM5CeCjQyWcW/g8LfWTzOVF9lzbx6IfEZDDoDem4+ZiPsAXC
 SWKBKil3npdbgb8MARPes2DpuhVm8yfkJEQQmuLYv8GPiJbwHQVLZGQAPBZSAc7IidD2zbf9
 XAw1/SJGe1poxOMfuSBsfKxv9ba2i8hUR+PH7gWwkMQaQ97B1yXYxVEkpG8Y4MfE5Vd3bjJU
 kvQ/tOBUCw5zwyIRC9+7zr1zYi/3hk+OG8OryZ5kpILBNCo+aePeAJ44znrySarUqS69tuXd
 a3lMPHUJJpUpIwSKQ5UuYYkWlWwENEWSefpakFAIwY4YIBkzoJ/t+XJHE1HTaJnRk6SWpeDf
 CreF3+LouP4njyeLEjVIMzaEpwROsw++BX5i5vTXJB+4UApTAQARAQABtChDYXNleSBTY2hh
 dWZsZXIgPGNhc2V5QHNjaGF1Zmxlci1jYS5jb20+iQJUBBMBCAA+FiEEC+9tH1YyUwIQzUIe
 OKUVfIxDyBEFAlzV9HACGwMFCRLMAwAFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQOKUV
 fIxDyBG6ag/6AiRl8yof47YOEVHlrmewbpnlBTaYNfJ5cZflNRKRX6t4bp1B2YV1whlDTpiL
 vNOwFkh+ZE0eI5M4x8Gw2Oiok+4Q5liA9PHTozQYF+Ia+qdL5EehfbLGoEBqklpGvG3h8JsO
 7SvONJuFDgvab/U/UriDYycJwzwKZuhVtK9EMpnTtUDyP3DY+Q8h7MWsniNBLVXnh4yBIEJg
 SSgDn3COpZoFTPGKE+rIzioo/GJe8CTa2g+ZggJiY/myWTS3quG0FMvwvNYvZ4I2g6uxSl7n
 bZVqAZgqwoTAv1HSXIAn9muwZUJL03qo25PFi2gQmX15BgJKQcV5RL0GHFHRThDS3IyadOgK
 P2j78P8SddTN73EmsG5OoyzwZAxXfck9A512BfVESqapHurRu2qvMoUkQaW/2yCeRQwGTsFj
 /rr0lnOBkyC6wCmPSKXe3dT2mnD5KnCkjn7KxLqexKt4itGjJz4/ynD/qh+gL7IPbifrQtVH
 JI7cr0fI6Tl8V6efurk5RjtELsAlSR6fKV7hClfeDEgLpigHXGyVOsynXLr59uE+g/+InVic
 jKueTq7LzFd0BiduXGO5HbGyRKw4MG5DNQvC//85EWmFUnDlD3WHz7Hicg95D+2IjD2ZVXJy
 x3LTfKWdC8bU8am1fi+d6tVEFAe/KbUfe+stXkgmfB7pxqW5Ag0EXNX0cAEQAPIEYtPebJzT
 wHpKLu1/j4jQcke06Kmu5RNuj1pEje7kX5IKzQSs+CPH0NbSNGvrA4dNGcuDUTNHgb5Be9hF
 zVqRCEvF2j7BFbrGe9jqMBWHuWheQM8RRoa2UMwQ704mRvKr4sNPh01nKT52ASbWpBPYG3/t
 WbYaqfgtRmCxBnqdOx5mBJIBh9Q38i63DjQgdNcsTx2qS7HFuFyNef5LCf3jogcbmZGxG/b7
 yF4OwmGsVc8ufvlKo5A9Wm+tnRjLr/9Mn9vl5Xa/tQDoPxz26+aWz7j1in7UFzAarcvqzsdM
 Em6S7uT+qy5jcqyuipuenDKYF/yNOVSNnsiFyQTFqCPCpFihOnuaWqfmdeUOQHCSo8fD4aRF
 emsuxqcsq0Jp2ODq73DOTsdFxX2ESXYoFt3Oy7QmIxeEgiHBzdKU2bruIB5OVaZ4zWF+jusM
 Uh+jh+44w9DZkDNjxRAA5CxPlmBIn1OOYt1tsphrHg1cH1fDLK/pDjsJZkiH8EIjhckOtGSb
 aoUUMMJ85nVhN1EbU/A3DkWCVFEA//Vu1+BckbSbJKE7Hl6WdW19BXOZ7v3jo1q6lWwcFYth
 esJfk3ZPPJXuBokrFH8kqnEQ9W2QgrjDX3et2WwZFLOoOCItWxT0/1QO4ikcef/E7HXQf/ij
 Dxf9HG2o5hOlMIAkJq/uLNMvABEBAAGJAjwEGAEIACYWIQQL720fVjJTAhDNQh44pRV8jEPI
 EQUCXNX0cAIbDAUJEswDAAAKCRA4pRV8jEPIEWkzEACKFUnpp+wIVHpckMfBqN8BE5dUbWJc
 GyQ7wXWajLtlPdw1nNw0Wrv+ob2RCT7qQlUo6GRLcvj9Fn5tR4hBvR6D3m8aR0AGHbcC62cq
 I7LjaSDP5j/em4oVL2SMgNTrXgE2w33JMGjAx9oBzkxmKUqprhJomPwmfDHMJ0t7y39Da724
 oLPTkQDpJL1kuraM9TC5NyLe1+MyIxqM/8NujoJbWeQUgGjn9uxQAil7o/xSCjrWCP3kZDID
 vd5ZaHpdl8e1mTExQoKr4EWgaMjmD/a3hZ/j3KfTVNpM2cLfD/QwTMaC2fkK8ExMsz+rUl1H
 icmcmpptCwOSgwSpPY1Zfio6HvEJp7gmDwMgozMfwQuT9oxyFTxn1X3rn1IoYQF3P8gsziY5
 qtTxy2RrgqQFm/hr8gM78RhP54UPltIE96VywviFzDZehMvuwzW//fxysIoK97Y/KBZZOQs+
 /T+Bw80Pwk/dqQ8UmIt2ffHEgwCTbkSm711BejapWCfklxkMZDp16mkxSt2qZovboVjXnfuq
 wQ1QL4o4t1hviM7LyoflsCLnQFJh6RSBhBpKQinMJl/z0A6NYDkQi6vEGMDBWX/M2vk9Jvwa
 v0cEBfY3Z5oFgkh7BUORsu1V+Hn0fR/Lqq/Pyq+nTR26WzGDkolLsDr3IH0TiAVH5ZuPxyz6
 abzjfg==
Message-ID: <105cf6a1-cd6a-016a-3557-dda0e5c7d9b5@schaufler-ca.com>
Date:   Fri, 3 Apr 2020 08:50:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200403153041.GA2787@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.15620 hermes Apache-HttpAsyncClient/4.1.4 (Java/11.0.6)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/3/2020 8:30 AM, Jarkko Sakkinen wrote:
> On Fri, Apr 03, 2020 at 07:35:16AM -0700, Casey Schaufler wrote:
>> On 4/2/2020 11:56 PM, Jarkko Sakkinen wrote:
>>> On Thu, Apr 02, 2020 at 02:41:39PM -0700, Andy Lutomirski wrote:
>>>> On Tue, Mar 31, 2020 at 5:24 PM Sean Christopherson
>>>> <sean.j.christopherson@intel.com> wrote:
>>>>> On Tue, Mar 31, 2020 at 10:39:38AM -0700, Andy Lutomirski wrote:
>>>>>
>>>>> If EXECMEM is a sticking point, one way to dodge it would be to add=
 a
>>>>> helper to allow SELinux to detect enclave files.  It'd be ugly, but=
 simple.
>>>>> That doesn't solve the generic labeling issue though.  It also begs=
 the
>>>>> question of why hacking SELinux but not do_mmap() would be acceptab=
le.
>>>>>
>>>>> If you have any ideas for fixing the noexec issue without resorting=
 to an
>>>>> anon inode, we're all ears.
>>>> Hmm.  Maybe teach udev to put /dev/sgx on a different fs and
>>>> bind-mount it?  Or make /dev/sgx be an actual filesystem?  Or just
>>>> mount /dev with exec enabled?
>>> I'm not forseeing how the last option could work out as it is distro'=
s
>>> choice.
>>>
>>> Casey, do you think we could use securityfs for this or do you have s=
ome
>>> other recommendation? I'm just asking you because you've used securit=
yfs
>>> a lot.
>> I don't know how well securityfs works when mounted in a container,
>> but otherwise it would seem like a viable option. On the other hand,
>> pseudo filesystems are pretty easy to write, so /sys/fs/sgxfs wouldn't=

>> be a bad choice, either.
> Ugh, sorry, forgot for a while that smackfs is independent fs.
>
> How does smackfs interact with namespaces?

Smack attributes are global. Aside from privilege issues, namespaces
ignore and are ignored by Smack.

>
> /Jarkko

